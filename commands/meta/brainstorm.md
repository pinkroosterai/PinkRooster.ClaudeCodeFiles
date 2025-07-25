# Brainstorm - Creative Thinking Assistant

---
description: Provides imaginative, novel brainstorming with configurable creativity levels and constraints
tools:
  - Task
  - mcp__sequential-thinking__sequentialthinking
  - WebSearch
  - mcp__context7__resolve-library-id
  - mcp__context7__get-library-docs
parameters:
  - name: level
    type: enum
    description: The degree of creative thinking to apply
    enum: ["moderate", "high", "unconventional"]
    default: "high"
    required: false
  - name: elements
    type: array
    description: Specific creative elements to incorporate (e.g., metaphor, wordplay, narrative)
    required: false
  - name: constraints
    type: array
    description: Optional creative constraints to work within
    required: false
transformationTemplate:
  instruction: "Please provide an imaginative, novel, and original response that uses creative language and unexpected connections to engage the reader."
  parameterMapping:
    level:
      valueMap:
        moderate: "Use creativity to make the content engaging while ensuring it remains accessible and practical. Incorporate creative elements that enhance understanding without overshadowing the substance."
        high: "Apply significant creative thinking to present the information in fresh, surprising ways. Use vivid language, unexpected angles, and novel framing to create an engaging and memorable response."
        unconventional: "Push far beyond conventional thinking to create a truly original response. Break traditional patterns, challenge assumptions, and explore highly unusual perspectives or approaches."
    elements:
      format: "Specifically incorporate these creative elements in your response: {value}."
    constraints:
      format: "While being creative, work within these constraints: {value}."
  placement: "prepend"
  compositionBehavior: "accumulate"
---

## Creative Brainstorming Process

### Context Gathering
Understanding the brainstorming topic and requirements to tailor the creative approach.

### Creativity Level Configuration
Based on the `level` parameter:

**Moderate Creativity**: Balanced approach that enhances understanding while maintaining practicality
- Focus on accessible creative elements
- Use metaphors and analogies to clarify concepts
- Maintain clear connection to practical applications
- Enhance engagement without overshadowing substance

**High Creativity**: Significant creative thinking with vivid language and unexpected angles
- Employ surprising perspectives and novel framing
- Use rich, evocative language and imagery
- Create memorable connections and insights
- Challenge conventional thinking patterns
- Incorporate storytelling and narrative elements

**Unconventional Creativity**: Push boundaries with truly original thinking
- Break traditional patterns and challenge assumptions
- Explore highly unusual perspectives and approaches
- Combine disparate concepts in unexpected ways
- Question fundamental premises
- Create entirely new frameworks for understanding

### Creative Elements Integration
When specific creative elements are requested, integrate them strategically:

**Metaphor**: Draw connections between disparate concepts to illuminate new understanding
**Wordplay**: Use linguistic creativity to create memorable and engaging content
**Narrative**: Structure ideas as stories to create emotional connection and memorability
**Visual Imagery**: Paint vivid mental pictures to enhance comprehension
**Analogy**: Use familiar concepts to explain complex ideas
**Paradox**: Explore contradictions to reveal deeper truths
**Personification**: Give human qualities to abstract concepts
**Humor**: Use appropriate wit to make ideas more engaging and memorable

### Constraint Management
When working within specified constraints:
- Identify the boundaries and use them as creative catalysts
- Find innovative solutions within the given limitations
- Transform constraints into creative opportunities
- Maintain adherence while maximizing creative expression

### Implementation Strategy

1. **Topic Analysis**: Deeply understand the brainstorming subject
2. **Creative Framework Selection**: Choose appropriate creative techniques based on level and elements
3. **Constraint Integration**: Work constraints into the creative process as generators rather than limiters
4. **Multi-Perspective Exploration**: Examine the topic from multiple unusual angles
5. **Connection Generation**: Create unexpected links between concepts
6. **Synthesis**: Combine ideas into novel and engaging insights

### Agent Integration
For complex brainstorming sessions, consider using specialized agents:
- **problem-solver**: For systematic creative problem decomposition
- **research-documenter**: For gathering creative inspiration from external sources
- **general-purpose**: For comprehensive creative exploration

### Output Format
The brainstorming response will:
- Apply the specified creativity level consistently
- Incorporate requested creative elements naturally
- Respect all specified constraints
- Provide actionable and engaging insights
- Use language appropriate to the creativity level
- Create memorable and impactful content

### Usage Examples

#### Basic High-Level Brainstorming
```
/brainstorm How can we improve team collaboration in remote work environments?
```

#### Moderate Creativity with Constraints
```
/brainstorm --level moderate --constraints "must be implementable within 30 days, budget under $1000" Ways to boost employee engagement
```

#### Unconventional Approach with Creative Elements
```
/brainstorm --level unconventional --elements "metaphor,narrative,wordplay" Innovative approaches to customer onboarding
```

#### Multi-Element Creative Session
```
/brainstorm --level high --elements "visual imagery,paradox,humor" --constraints "suitable for C-suite presentation" Digital transformation strategies
```

### Quality Assurance
- Ensure creativity level is consistently applied throughout
- Verify all requested elements are meaningfully incorporated
- Confirm all constraints are respected
- Validate that the response is both creative and actionable
- Check that unexpected connections enhance rather than confuse understanding

This command transforms any brainstorming request into a creatively enhanced exploration that engages the reader while maintaining practical value and respecting specified parameters.