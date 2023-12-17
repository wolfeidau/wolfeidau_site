+++
title = "Getting started with AI for developers"
date = "2023-12-16T08:55:22+10:00"
tags = [ "artificial intelligence", "learning", "llms", "security", "software development", "developer tools"]
+++

As a software developer, I have seen a lot of changes over the years, however few have been as drastic as the rise of artificial intelligence. There are a growing list of tools and services using this technology to help developers with day to day tasks, and speed up their work, however few of these tools help them understand how this technology works, and what it can do. So I wanted to share some of my own tips on how to get started with AI.

The aim of this exercise is to help develop some intuition of how AI works, and how it can be used to help in your day-to-day tasks, while hopefully discovering ways to use it in future applications you build.

## Getting Started

As the common saying that originated from a Chinese proverb says.
> A journey of a thousand miles begins with a single step.

To kick off your understanding of AI I recommend you select a coding assistant and start using it on your personal, or side projects, this will provide you with a better understanding of how it succeeds, and sometimes fails. Building this knowledge up will help you develop an understanding of strengths and weaknesses as a user.

I personally recommend getting started with [Cody](https://about.sourcegraph.com/cody) as it is a great tool, and is free for personal use, while also being open source itself. The developers of Cody are very open and helpful, and have a great community of users, while also sharing their own experiences while building the tool.

Cody is more than just a code completion tool, you can ask it questions and get it to summarise and document your code, and even generate test cases. Make sure you explore all the options, again to build up more knowledge of how these AI tools work.

And most importantly be curios, and explore every corner of the tool.

## Diving Into LLMs

Next, I recommend you start experimenting with some of the open source large language models (LLMs) using tools such as [ollama](https://ollama.ai/) to allow you to download, run and experiment with the software. To get started with this tool, you can follow the quick start in the `README.md` hosted at https://github.com/jmorganca/ollama. Also there is a great intro by Sam Witteveen [Ollama - Local Models on your machine](https://www.youtube.com/watch?v=Ox8hhpgrUi0&t=2s) which I highly recommend.

## What is a large language model?

Here is a quote from [wikipedia on what a large language model](https://en.wikipedia.org/wiki/Large_language_model) is:
> A large language model (LLM) is a large scale language model notable for its ability to achieve general-purpose language understanding and generation. LLMs acquire these abilities by using massive amounts of data to learn billions of parameters during training and consuming large computational resources during their training and operation. LLMs are artificial neural networks (mainly [transformers](https://en.wikipedia.org/wiki/Transformer_(machine_learning_model)) and are (pre)trained using self-supervised learning and semi-supervised learning.

## Why Open LLMs?

I prefer to learn from the open LLMs for the following reasons:

1. They have a great community of developers and users, who share information about the latest developments.
2. You get a broader range of models, and can try them out and see what they do.
3. You can run them locally with your data, and see what they do without some of the privacy concerns of cloud based services.
4. You have the potential to fine tune them to your data, and improve the performance.

I keep up with the latest developments I use [hugging face open llm leader board](https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard), as they have been doing a lot of work on large language models, and have a great community of users. When the latest models are posted they are also sharing their experiences, and fine tuned versions via their [blog](https://huggingface.co/blog), which is great resource. Notable models are normally added to ollama after a day or so, so you can try them out and see what they do.

There are a number of different types of LLMs, each with their own strengths and weaknesses. I personally like to experiment with the chat bot models, as they are very simple to use, and are easy to interface with via olloma. An example of one of these from the hugging face site is https://huggingface.co/mistralai/Mistral-7B-v0.1 which is a chat bot model trained by the [Mistral AI](https://mistral.ai/) team. 

To get started with this model you can follow the instructions at https://ollama.ai/library/mistral, download and run the model locally.

## Pick a Scenario To Test

My scenario relates to my current role, and covers questions which my team encounters on a day-to-day basis. As a team we are providing advice to a customers about how to improve the operational readiness and security posture for internally developed applications. This is a common scenario for many companies, where applications are developed to provide a proof of concept, and are then deployed to a production environment without the supporting processes in place.

What is approach is helpful as:

1. This is a scenario I can relate to, and can use my existing knowledge to review the results.
2. This is a scenario which is not too complex, and can be used to demonstrate the concepts.
3. This is a scenario which will provide me value while I am learning how to use the tools.

## Building a list of questions

Once you have a scenario, you can draft a list of questions which you can start testing them with models, this will help you understand how the models work, and how they can be to support a team or business unit, while also learning how to use them.

The questions I am currently using mainly focus on DevOps, and SRE processes, paired with a dash of [AWS](https://aws.amazon.com/) security and terraform questions.

### I need to create a secure environment in and AWS Account, where should I start?

This question is really common for developers starting out in AWS, it is quite broad and I am mostly expecting a high level overview of how to create a secure environment, and how to get started.

### How would I create an encrypted secure s3 bucket using terraform?

This question is a bit more specific, focusing on a single AWS service, while also adding a few specific requirements. Models like Mistral will provide a step by step guide on how to achieve this, while others will provide the terraform code to achieve this.

### I need to create an Application Risk Management Program, where should I start?

This question is quite common if your working in a company which doesn't have a long history with internal software development, or a team that is trying to ensure they cover the risks of their applications.

### What is a good SRE incident process for a business application?

This question is also quite broad, but includes Site Reliability Engineering (SRE) as a keyword, so I am expecting an answer which aligns with the principals of this movement.

## What is a good checklist for a serverless developer who wants to improve the monitoring of their applications?

This is a common question asked by people who are just getting started with serverless and are interested in, or have been asked to improve the monitoring of their applications.

## Whats Next?

So now that you have a scenario and a few questions I recommend you do the following:

1. Try a couple of other models, probably [llama2](https://ollama.ai/library/llama2) and [orca](https://ollama.ai/library/orca2) are a good starting point.
2. Learn a bit about prompting by following [A guide to prompting Llama 2](https://replicate.com/blog/how-to-prompt-llama) from the replicate blog.
3. Apply the prompts to your ollama model using a [modelfile](https://github.com/jmorganca/ollama/blob/main/docs/modelfile.md), which is similar to a [Dockerfile](https://docs.docker.com/engine/reference/builder/).
3. Try out an uncensored model, something like [llama2-uncensored](https://ollama.ai/library/llama2-uncensored) and run through your questions, then ask about breaking into cars or killing processes, which can be a problematic question in some censored models. It is good to understand what censoring a model does, as it can be a useful tool for understanding the risks of using a model.
4. Start reading more about [The State of Open Source AI (2023 Edition)](https://github.com/premAI-io/state-of-open-source-ai).

## Further Research

Now that you are dabbling with LLMs, and AI, I recommend you try these models for the odd question in your day-to-day work, the local ones running in ollama are restively safe, and they can save you a lot of work. 

Also try similar questions with services such as https://chat.openai.com/, hosted services are a powerful tool for adhoc testing and learning. Just be aware of data privacy, and security when using these services.

Once you have some experience you will hopefully even incorporate a model into work projects such as data cleansing, summarizations, or processing of user feedback to help you improve your applications. For this you can use services such as [AWS Bedrock](https://aws.amazon.com/bedrock/) on AWS, or [Generative AI Studio](https://cloud.google.com/generative-ai-studio) on Google cloud, while following the same methodology to evaluate and select a model for your use case.

If your intrigued and want to go even deeper than these APIs, I recommend you dive into some of the amazing resources on the web for learning how AI and LLMs work, and possibly even develop, or fine tune your own own models.

* [fast.ia](https://www.fast.ai/) which provides some great online self paced learning on AI.
* [A busy persons intro to LLMs](https://www.youtube.com/watch?v=zjkBMFhNj_g) great lecture on LLMs.
* [MIT Introduction to Deep Learning](http://introtodeeplearning.com/) for those who want to dive deeper and prefer more of a structured course.
* [A Hackers' Guide to Language Models](https://www.youtube.com/watch?v=jkrNMKz9pWU), another great talk by Jeremy Howard of fast.ai.