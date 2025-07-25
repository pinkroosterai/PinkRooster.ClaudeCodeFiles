---
allowed-tools: [Bash, Write, Read, Glob, Task]
description: Create a new custom slash command with intelligent templates and agent integration
argument-hint: <command-name> [description] [--scope=project|user] [--namespace=category] [--template=type] [--agent=specialist]
---

# Create Custom Slash Command

Create a new slash command with the name and specifications from: $ARGUMENTS

## Current Command Context

Existing project commands: !`ls -la .claude/commands/ 2>/dev/null || echo "No project commands directory"`
Existing user commands: !`ls -la ~/.claude/commands/ 2>/dev/null || echo "No user commands directory"`
Command structure: !`find .claude/commands ~/.claude/commands -name "*.md" 2>/dev/null | head -10`

## Command Template Types

Based on existing commands, choose appropriate template:
- **analysis**: Code review, pattern detection, quality assessment (like code-review-dry)
- **implementation**: Code generation, feature building, problem-solving
- **workflow**: Git operations, deployment, automation (like git-commit)
- **meta**: Command creation, project setup, tooling

## get-context Usage Reference
!`get-context`

## Enhanced Command Creation Process

### 1. Intelligent Argument Parsing
   - Extract command name from $ARGUMENTS (required)
   - Parse optional description, scope, namespace, template, and agent preferences
   - Validate command name follows kebab-case convention
   - Check for conflicts with existing commands
   - Determine optimal namespace based on command purpose and existing structure

### 2. Smart Template Selection
   - **Analysis Template**: For code review, pattern detection, quality assessment
     - Includes context gathering, systematic analysis phases, severity classification
     - Standard output format with examples and recommendations
   - **Implementation Template**: For building features, solving problems
     - Includes planning phase, iterative development, validation steps
   - **Workflow Template**: For automation, git operations, deployment
     - Includes status checks, error handling, safety features
   - **Meta Template**: For tooling, command creation, project setup
     - Includes context analysis, structure creation, validation

### 3. Agent Integration Recommendations
   Based on command purpose, suggest appropriate agents to execute the different steps.

### 4. Clarification Questions
   Ask contextual questions based on template type:
   
   **For Analysis Commands**:
   - What specific patterns or issues should it detect?
   - What severity levels should it support?
   - Should it provide refactoring suggestions?
   
   **For Implementation Commands**:
   - What programming languages/frameworks are involved?
   - Should it use specific agents for specialized tasks?
   - What validation or testing is required?
   
   **For Workflow Commands**:
   - What safety checks are needed?
   - Should it support interactive mode?
   - What error conditions should it handle?

### 5. Intelligent Directory Structure Creation
   - Use mkdir -p to create nested namespace paths
   - For project commands: `.claude/commands/[namespace]/`
   - For user commands: `~/.claude/commands/[namespace]/`
   - Suggest namespace based on command type:
     - review/ for analysis commands
     - implementation/ for building features
     - workflow/ for automation
     - meta/ for tooling commands

### 6. Command File Generation
   - Analyze existing command file for structure and formatting
   - Generate appropriate YAML frontmatter with intelligent tool permissions
   - Include template-specific sections and workflow steps
   - Add proper context-gathering commands using get-context
   - Execute bash commands before the slash command runs using the ! prefix. The output is included in the command context. Use the ! prefix only for immediate bash command execution in the Context Gathering section.
   - Include agent invocation examples where applicable
   - Add comprehensive error handling and validation
   - Include usage examples and argument patterns

### 7. Tool Permission Intelligence
   Automatically suggest tools based on command type:
   - **Analysis**: Bash, Glob, Grep, Read, serena tools for code analysis
   - **Implementation**: Write, Edit, MultiEdit, Bash, Task for agent integration
   - **Workflow**: Bash, WebFetch, specialized automation tools
   - **Meta**: All file operations, directory management tools

### 8. Validation and Testing
   - Use ls to confirm file creation and proper naming
   - Read back generated content for syntax validation
   - Check YAML frontmatter parsing
   - Verify command follows established patterns
   - Test example usage scenarios

### 9. Comprehensive Usage Instructions
   - Show complete command syntax with all options
   - Provide multiple usage examples
   - Explain argument patterns and optional flags
   - Document integration with agents where applicable
   - Include troubleshooting common issues

### 10. Quality Assurance
   - Ensure command follows naming conventions
   - Validate description clarity and completeness
   - Check for proper markdown formatting
   - Verify agent integration recommendations
   - Confirm template appropriateness for command purpose

## Command Creation Workflow

1. **Parse and validate arguments** from $ARGUMENTS
2. **Determine optimal template type** based on command purpose  
3. **Select appropriate namespace** or create new one if needed
4. **Recommend agent integration** based on command functionality
5. **Ask targeted clarification questions** specific to template type
6. **Create directory structure** with proper permissions
7. **Generate command file** using intelligent template selection
8. **Validate creation** with comprehensive testing
9. **Provide usage documentation** with examples and agent usage

## Enhanced Error Handling

- **Invalid command name**: Suggest proper kebab-case formatting
- **Namespace conflicts**: Recommend alternative namespaces
- **Permission issues**: Guide through directory creation troubleshooting  
- **Template mismatches**: Suggest better template for command purpose
- **Missing agent integration**: Recommend appropriate agents for complex tasks

## Integration Examples

### Using Task Tool with Agents
```markdown
## Implementation Phase
Use the Task tool to engage appropriate specialists:
- For C# implementation: `Task(description="Implement feature", subagent_type="csharp-code-generator")`
- For architecture decisions: `Task(description="Design system", subagent_type="system-architect")`
- For troubleshooting: `Task(description="Debug issue", subagent_type="diagnostic-troubleshooter")`
```

