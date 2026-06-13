+++
title = "AI Is Bringing Mashups Back"
date = "2026-06-12T08:55:22+10:00"
tags = ["developer tools", "llms", "ai", "ai agents"]
draft = true
+++

A [mashup](https://en.wikipedia.org/wiki/Mashup_(web_application_hybrid)) is a term that became popular in the 2010s for applications that combined two or more data sources into a single user interface. Recently, I have seen a steady stream of AI-generated side projects, small apps, slide decks, and useful tools showing up on social media, often built by people who have never tried this before. With the advent of [ChatGPT](https://chatgpt.com/) and [Claude](https://claude.ai/), it has never been easier to integrate disparate data and build something useful.

These mashups are nothing new, but the barrier to entry is much lower, and the scale of what is possible has changed as AI models and tools improve.

I have also seen these mashups at work, which is fantastic because it gives more people the ability to build tools and explore problems without waiting on software engineering teams.

This is good for everyone for a few reasons:

* provides more value from internal data sources
* includes visualisations that highlight trends or patterns
* requires minimal programming skills

## What is new about this?

The key differentiator is the scale and complexity of these mashups. With the help of tools like [Claude Code](https://claude.com/product/claude-code), [Codex](https://openai.com/codex/), and [Cursor](https://cursor.com/), people can build functional web or mobile applications.

This matters for a few reasons:

1. It is easier than ever to integrate disparate services using APIs.
2. Agents can respond to queries and follow up with users.
3. Integrating authentication or data storage is easier than ever.
4. The explosion of [agent skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) has unlocked even more capabilities, allowing users to package and share repeatable processes.

Overall, this has led to a Cambrian explosion of mashups, with a wave of new users publishing and sharing their projects.

## How will this affect existing SaaS providers?

After chatting with my peers at events such as the [AI Engineer conference in Melbourne](https://webdirections.org/ai-engineer/), it is clear that we are seeing people with domain knowledge and a clear problem to solve build mashups that automate day to day operational tasks and provide improved operational reporting.

Businesses are building their own portals, combining feeds of data from multiple platforms with tools such as [openclaw](https://openclaw.ai/) to act as the nerve centre for their business. These portals combine APIs, [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) servers, messaging, and agents to drive day to day operational tasks and provide integrated reporting that would be impossible for any one platform.

For example, a team might combine CRM data, email notifications from an online store, and supplier invoices into a small internal portal that shows business health and triggers follow-up actions through openclaw.

As a side effect of this, SaaS providers are seeing:

1. Less traffic to user interfaces, with people using them mainly when configuring new features or diagnosing more complex issues.
2. Widespread use of MCP, which provides a more accessible interface for agents.
3. More API traffic from customers.

I think it is important to understand that the people building these mashups are often just looking to solve their own business problems, typically in ways that are specific to their business.

## How can platforms better support mashups?

If platforms want to support this new wave of mashups, then composability needs to be a priority.

Some areas to focus on are:

* Stable documented APIs, with versioning, predictable schemas, useful errors, and clear deprecation windows.
* Solid authentication for delegated access, including standardised OAuth/OIDC flows with scoped permissions that make sense to users and developers.
* Fine-grained permissions, because a mashup might only need read access to one dataset, one workspace, or one resource type.
* Security controls that protect customers as their mashups evolve, including audit logs, policy enforcement, token expiry, and clear visibility into connected tools.
* Webhooks and event streams, with support for replay, signing, delivery logs, and retry behaviour so integrations do not need to rely on polling.
* Reasonable rate limits, which should be visible, documented, and returned in headers.
* Examples that compose multiple services and show real integration patterns: sync jobs, event-driven workflows, import/export, embedded views, and permission handling.

The most successful platforms will make integration easy by providing stable primitives, clear boundaries, and well-documented capabilities.

## Summary

Mashups have seen a resurgence because AI tools make it much easier for anyone to combine data, APIs, and user interfaces without waiting for a full software delivery process.

Key points:

* Mashups are not new, but the barrier to entry is much lower, and the scale of what is possible has changed as AI models and tools improve.
* More people can now build useful internal tools from existing data sources.
* SaaS providers should expect more API and MCP usage, and less reliance on their default user interfaces.
* Good security controls help keep customers safe while these mashups evolve from experiments into operational tools.
* Platforms that invest in composability, stable APIs, delegated authentication, webhooks, and good examples will be easier to build on.
