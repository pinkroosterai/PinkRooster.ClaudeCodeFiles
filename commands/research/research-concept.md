# Research Concept

Research and document a programming concept, technology, or framework using comprehensive web research and structured documentation generation.

## Usage

```bash
/research-concept [concept] [--depth=basic|detailed|comprehensive] [--output=docs/filename.md] [--format=reference|guide|tutorial]
```

## Arguments

- `concept` (required): The programming concept, technology, framework, or topic to research
- `--depth`: Research depth level (default: detailed)
  - `basic`: Overview and key points only
  - `detailed`: Comprehensive coverage with examples
  - `comprehensive`: In-depth analysis with multiple perspectives
- `--output`: Specify output file path (default: docs/[concept]-reference.md)
- `--format`: Documentation format (default: reference)
  - `reference`: Technical reference documentation
  - `guide`: How-to guide with practical examples
  - `tutorial`: Step-by-step learning material

## Examples

```bash
# Research Entity Framework Core with detailed coverage
/research-concept "Entity Framework Core" --depth=detailed

# Create a comprehensive guide for microservices
/research-concept "microservices architecture" --depth=comprehensive --format=guide --output=docs/microservices-guide.md

# Basic reference for a specific library
/research-concept "Serilog" --depth=basic --format=reference
```

---

## Context Gathering

!get-context project

## Research and Documentation Process

### Phase 1: Research Planning

Use the Task tool to engage the research-documenter agent for systematic research:

```
Task(
  description="Research and document [concept]", 
  subagent_type="research-documenter",
  prompt="Research the concept: $ARGUMENTS

Create comprehensive documentation covering:
- What it is and why it's important
- Key features and capabilities  
- Use cases and applications
- Best practices and patterns
- Code examples and implementations
- Common pitfalls and solutions
- Related technologies and alternatives
- Learning resources and references

Research depth: $DEPTH
Output format: $FORMAT
Target audience: Software developers and architects"
)
```

### Phase 2: Content Validation

The research-documenter agent will:
1. **Web Research**: Search for authoritative sources, documentation, and examples
2. **Content Synthesis**: Organize findings into structured documentation
3. **Example Generation**: Create relevant code examples and use cases
4. **Quality Review**: Ensure accuracy, completeness, and clarity
5. **Reference Compilation**: Gather authoritative sources and further reading

### Phase 3: Documentation Generation

Based on the specified format:

**Reference Format**:
- Technical overview and architecture
- API documentation and interfaces
- Configuration options and parameters
- Code examples and snippets
- Troubleshooting and FAQ

**Guide Format**:
- Problem-solution approach
- Step-by-step implementation
- Real-world scenarios
- Best practices and patterns
- Performance considerations

**Tutorial Format**:
- Learning objectives
- Prerequisites and setup
- Progressive examples
- Exercises and challenges
- Next steps and advanced topics

### Phase 4: Integration and Storage

1. **File Creation**: Save documentation to specified output path
2. **Project Integration**: Link to existing documentation structure
3. **Index Update**: Add to project documentation index if applicable
4. **Knowledge Base**: Store key insights for future reference

## Output Structure

The generated documentation will follow this structure:

```markdown
# [Concept Name]

## Overview
Brief introduction and importance

## Key Features
Main capabilities and characteristics

## Use Cases
Common applications and scenarios

## Implementation
Code examples and practical usage

## Best Practices
Recommended patterns and approaches

## Common Issues
Troubleshooting and solutions

## Related Technologies
Alternatives and complementary tools

## References
Authoritative sources and further reading
```

## Agent Integration

This command leverages the **research-documenter** agent which specializes in:
- Comprehensive web research using multiple sources
- Technical documentation creation following industry standards
- Code example generation and validation
- Cross-referencing and fact-checking
- Structured knowledge organization

## Error Handling

- **Invalid concept**: Suggests similar or related topics
- **Research failures**: Falls back to basic documentation with available information
- **Output path issues**: Creates necessary directories and handles file conflicts
- **Format mismatches**: Adapts content structure to specified format

## Notes

- Research is performed using current web sources for up-to-date information
- Generated documentation includes publication date and source attribution
- Code examples are validated for syntax and best practices
- Output files are created with proper markdown formatting and structure

## Integration with Project

The command automatically:
- Creates documentation in the project's docs/ directory
- Follows existing documentation patterns and structure
- Links to related concepts in the project
- Updates documentation index when applicable