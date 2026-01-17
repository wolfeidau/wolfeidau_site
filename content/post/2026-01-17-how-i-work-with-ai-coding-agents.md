+++
title = "How I Work with AI Coding Agents"
date = "2025-12-07T08:55:22+10:00"
tags = [ "collaboration", "software development", "developer tools", "llms", "ai", "ai agents"]
+++

For anyone who has been following AI and software development, things are changing rapidly, this includes how we build software. Over the last few months, I have found myself going from working alone to working with an AI agent, such as [Anthropic's Claude](https://claude.ai/), [OpenAI's Codex](https://openai.com/codex/), or [Google's Gemini CLI](https://geminicli.com/).

This change has been both exciting and challenging. With the help of this AI agent, I have been able to delegate tasks and focus on the most important things. That said, this has required a shift in my mindset and approach to working with AI.

## The death of the Chat Box

Over the last few months, I have found myself moving away from transactional interactions with AI agents via a chat box, to a more collaborative approach. Instead of asking the AI agent to fix an issue and then reviewing the results, I am now working in a more iterative way. This has led me to follow a more [specification driven development process](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html) which is a great way to ensure more predictable and reliable results.

This process looks like:

1. Provide some context on the problem, then work with the agent to put together a plan.
2. Review the plan, remove any unnecessary steps and focus on the most important ones. I then ask the agent to export the plan to a specification in a [markdown](https://daringfireball.net/projects/markdown/) file in the codebase.
3. I then reset the context and get the agent to review the specification and provide feedback. This typically highlights a few areas that need to be addressed.
4. If the specification looks good, and I am clear on the outcomes, then I instruct the agent to start work on the specification, this typically follows one or more phases.
5. I then do some testing, review the results and provide feedback.
6. I reset the context and get the agent to review the specification and the outcomes, then we update it with the results.
7. Finally, I clear the context and get the agent to review the outcomes and provide feedback, for code this is done using a code review skill or sub agent. Once we have completed this process I can commit the changes to the codebase.

This process is especially useful for most tasks, building new features, or refactoring existing ones, but I find a scaled back version of this process is even useful for small tasks, to ensure the agent is kept on track.

## Documentation is King

Documentation is the backbone of any software project and with the rise of AI, it is becoming even more important. The ability to quickly and easily create a specification, then iterate on it, and use it to drive the development process with an AI agent is key to ensuring work stays on track.

Why is maintaining a specification important?

* It helps you establish a clear goal and plan for what the AI agent is going to do.
* It provides a reference point for other developers and stakeholders.
* Once changes are complete the specification can be used to update the documentation used by customers.

The idea of documenting software isn't new, this has been practiced since people started writing software. I am personally enjoying this renaissance of documentation as everyone wins, from the developers who are writing the code to the customers who are using it.

## Conclusion

This is a new way of working. It won't be perfect, especially while you're figuring out how to work with the AI agent. But it is an opportunity to improve your productivity by embracing this new paradigm.

Key takeaways:

* Embrace specification driven development, as this is foundation of good software development.
* Ensure specifications are reviewed and questioned before the AI agent starts work, this avoids wasting time reworking, or removing pointless changes.
* Be collaborative with your AI agent, ask questions, sweat the details and be patient as you learn to build up your intuition and confidence with these tools.

One big thing to understand is AI Agents are especially valueble when tackling tasks you aren't familiar with. Tell the agent up front your goal is to solve a problem, and learn how it works, this will help the agent clearly understand the goals and provide the best possible outcomes.

## Links

* [ A recent side project specification written with Claude Code](https://gist.github.com/wolfeidau/0be9b3b56ebca452375404baddf33777)
* [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)