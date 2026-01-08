# Rules for React Components

## Prop Types
- Define prop types above component using `type` (not `interface`)
- Never define prop types inline in function arguments

## Component Definitions
- Use named function declarations for React components
- Export components/types on declaration
- Never use arrow functions or function expressions for named components

## Props Handling
- Never destructure props in function signature
- Always destructure props inside function body

## Hooks
- Import hooks individually (never `React.useEffect`)
- Avoid module namespace for React hooks
