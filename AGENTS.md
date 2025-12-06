

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: Bash("openskills read <skill-name>")
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>code-reviewer</name>
<description>"Review code for quality, bugs, and best practices"</description>
<location>project</location>
</skill>

<skill>
<name>inertia-rails</name>
<description>Building full-stack applications with Inertia.js in Rails using React. Use when working with Inertia responses, forms, props, redirects, React page components, or Rails controllers in an Inertia project.</description>
<location>project</location>
</skill>

<skill>
<name>programming-rails</name>
<description>Best practices for Ruby on Rails development across models, controllers, services, and background jobs</description>
<location>project</location>
</skill>

<skill>
<name>programming-ruby</name>
<description>Best practices when developing in Ruby codebases</description>
<location>project</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

You have access to kit-dev-mcp server with powerful code intelligence tools.

MANDATORY WORKFLOW for code tasks:
1. open_repository(path) - Load the codebase
2. get_file_tree() - Understand structure
3. extract_symbols() - Analyze code (cached)
4. For new libraries: deep_research_package()

TOOL DESCRIPTIONS:
- open_repository: Opens local/remote repositories
- get_file_tree: Shows project structure
- extract_symbols: Fast symbol extraction with caching
- get_file_content_multi: Read multiple files at once
- search_text: Powerful regex search
- find_symbol_usages: Find where symbols are used
- get_dependency_graph: Map import relationships
- deep_research_package: Research from multiple documentation sources

Always use these tools proactively. Don't wait to be asked.
Better context = Better code.