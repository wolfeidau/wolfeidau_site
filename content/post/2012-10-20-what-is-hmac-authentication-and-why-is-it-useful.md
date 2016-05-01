+++
date = "2012-10-20T00:00:00+11:00"
draft = false
title = "What is HMAC Authentication and why is it useful?"
categories = [ "OpenSSL", "NodeJS", "Ruby", "Java" ]

+++

To start with a little background, then I will outline the options for authentication of HTTP based server APIs with a focus on
HMAC and lastly I will provide some tips for developers building and using [HMAC](http://en.wikipedia.org/wiki/HMAC) based
authentication.


Recently I have been doing quite a bit of research and hacking in and around server APIs. Authentication for
these type APIs really depends on the type of service, and falls into a couple of general categories:

* Consumer or personal applications, these typically use a simple username and password, OAuth is used in some cases however this
is more for identity of an individuals authorisation session within a trusted third party.
* Infrastructure applications, these typically use a set of credentials which are different to the owners/admins credentials
 and provide some sort of automation API for business or devices to enhance the function or control something.

For infrastructure APIs I have had a look at a few options, these are explained in some detail below.

Basic Authentication
-------------

This is the simplest to implement and for some implementations can work well, however it requires transport level
encryption as the user name and password are presented with ever request. For more information on this see
[Wikipedia Article](http://en.wikipedia.org/wiki/Basic_access_authentication).

Digest Authentication
-------------

This is actually quite a bit closer to HMAC than basic, it uses md5 to hash the authentication attributes in a way which
makes it much more difficult to intercept and compromise the username and password attributes. Note I recommend reading over
the [Wikipedia page](http://en.wikipedia.org/wiki/Digest_access_authentication) on the subject, in short it is more than
secure than basic auth, however it is entirely dependent on how many of the safeguards are implemented in the client
software and the complexity of the password is a factor.

Note unlike basic authentication, this does not require an SSL connection, that said make sure you read the Wikipedia article
as there are some issues with man in the middle attacks.

HMAC Authentication
-------------

Hash-based message authentication code (HMAC) is a mechanism for calculating a message authentication code involving a hash function
in combination with a secret key. This can be used to verify the integrity and authenticity of a a message.

Unlike the previous authentication methods there isn't, as far as I can tell a standard way to do this within HTTP, that said as this
is the main authentication method used by [Amazon Web Services](http://aws.amazon.com) it is very well understood, and there are a number of
libraries which implement it. To use this form of authentication you utilise a key identifier and a secret key, with both
of these typically generated in an admin interface (more details below).

It is very important to note that one of the BIG difference with this type of authentication is it signs the entire request,
if the content-md5 is included, this basically guarantees the authenticity of the action. If a party in the middle fiddles
with the API call either for malicious reasons, or bug in a intermediary proxy that drops some important headers,the
signature will not match.

The use HMAC authentication a digest is computed using a composite of the URI, request timestamp and some other headers (dependeing
on the implementation) using the supplied secret key. The key identifier along with the digest, which is encoded using [Base64](http://en.wikipedia.org/wiki/Base64)
is combined and added to the authorisation header.

The following example is from [Amazon S3 documentation](http://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html).

{{< highlight ruby >}}
"Authorization: AWS " + AWSAccessKeyId + ":"  + base64(hmac-sha1(VERB + "\n"
                   + CONTENT-MD5 + "\n"
                   + CONTENT-TYPE + "\n"
                   + DATE + "\n"
                   + CanonicalizedAmzHeaders + "\n"
                   + CanonicalizedResource))
{{< /highlight >}}

Which results in a HTTP request, with headers which looks like this.

{{< highlight text >}}
PUT /quotes/nelson HTTP/1.0
Authorization: AWS 44CF9590006BF252F707:jZNOcbfWmD/A/f3hSvVzXZjM2HU=
Content-Md5: c8fdb181845a4ca6b8fec737b3581d76
Content-Type: text/html
Date: Thu, 17 Nov 2005 18:49:58 GMT
X-Amz-Meta-Author: foo@bar.com
X-Amz-Magic: abracadabra
{{< /highlight >}}

Note the AWS after the colon is sometimes known as the service label, most services I have seen follow the convention of changing this to
an abbreviation of their name or just HMAC.

If we examine the Amazon implementation closely a few advantages become obvious, over normal user names and passwords:

1. As mentioned HMAC authentication guarantees the authenticity of the request by signing the headers, this is especially
the case if content-md5 is signed and checked by the server AND the client.
2. An admin can generate any number of key pairs and utilise them independent of their Amazon credentials.
3. As noted before these are computed values and can be optimised to be as large as necessary, Amazon is using 40 character secrets for [SHA-1](http://en.wikipedia.org/wiki/SHA-1),
depending on the hash algorithm used.
4. This form of authentication can be used without the need for SSL as the secret is never actually transmitted, just the MAC.
5. As the key pairs are independent of admin credentials they can be deleted or disabled when systems are compromised therefor
disabling their use.

As far as disadvantages, there are indeed some:

1. Not a lot of consistency in the implementations outside of the ones which interface with Amazon.
2. Server side implementations are few in number, and also very inconsistent.
3. If you do decide to build your own be advised Cryptographic APIs like OpenSSL can be hard to those who haven't used them directly before, a single character difference will result in a completely different value.
4. In cases where all headers within a request are signed you need to be VERY careful at the server or client
side to avoid headers being injected or modified by your libraries (more details below).

------

As I am currently developing, and indeed rewriting some of my existing implementations I thought I would put together a
list of tips for library authors.

1. When writing the API ensure you check your request on the wire to ensure nothing has been changed or "tweaked" by the HTTP
library you're using, mine added a character encoding attribute to the Content-Type.
2. Test that order of your headers is correct on dispatch of the request as well, libraries my use an hash map (natural ordered),
this may break your signature depending on the implementation. In the case of Amazon they require you to sort your "extra"
headers alphabetically and lower case the header names before computing the signature.
3. Be careful of crazy Ruby libraries that snake case your header names (yes this is bad form) before presenting them
to your code as the list of header names.
4. When debugging print the canonical string used to generate the signature, preferably using something like
ruby inspect which shows ALL characters. This will help both debugging while developing, and to compare against what the server
side actually relieves.
5. Observe how various client or server APIs introduce or indeed remove headers.

From a security stand point a couple of basic recommendations.

1. Use content MD5 at both ends of the conversation.
2. Sign all headers which could influence the result of the operation as a minimum.
3. Record the headers of every API call that may have side affects, on most web servers this can be enabled and added to
the web logs (again ideally this would be encoded like what ruby inspect does).

So in closing I certainly recommend using HMAC authentication, but be prepared to learn a lot about how HTTP works and a
little Cryptography, this in my view cant hurt either way if you're building server side APIs.

Update
-------------

Based on some of the comments made when I submitted this to [hacker news](http://news.ycombinator.com/item?id=4676676) I have
compiled some extra links and observations.

One interesting point made was the issue of replay attacks, which is where a valid message is maliciously or fraudulently repeated or delayed. This is
either performed by the originator or by a man in the middle who retransmits the message, possibly as a part of a denial of service.

nonce
-------------

To protect from these types of attacks a [Cryptographic nonce](http://en.wikipedia.org/wiki/Cryptographic_nonce), which is an arbitrary number usable only
once in a message exchange between a client and a server. These are in fact optionally used within Digest authentication mentioned previously.

One of the comments linked an article which suggested use of nonce with HMAC as described in [RFC 5849 The OAuth 1.0 Protocol](http://tools.ietf.org/html/rfc5849#page-17). In this
specification an nonce is paired a timestamp and included with each message, the timestamp can be used to avoid the need to retain an infinite number of nonce values for
future checks, the server can reject messages with timestamps older than window of time nonce values are retained.

Based on the original post I have developed a flexible hmac authentication library called [Ofuda](https://github.com/wolfeidau/ofuda) for [nodejs](http://nodejs.org), this currently contains
a small routine to hmac sign a list of headers for a given request. In the near future I plan to add validation of a signature and an implementation of nonce based on the
aforementioned strategy.








