---
name: Silent Intelligence
colors:
  surface: '#131315'
  surface-dim: '#131315'
  surface-bright: '#39393b'
  surface-container-lowest: '#0e0e10'
  surface-container-low: '#1c1b1d'
  surface-container: '#201f22'
  surface-container-high: '#2a2a2c'
  surface-container-highest: '#353437'
  on-surface: '#e5e1e4'
  on-surface-variant: '#c2c6d6'
  inverse-surface: '#e5e1e4'
  inverse-on-surface: '#313032'
  outline: '#8c909f'
  outline-variant: '#424754'
  surface-tint: '#adc6ff'
  primary: '#adc6ff'
  on-primary: '#002e6a'
  primary-container: '#4d8eff'
  on-primary-container: '#00285d'
  inverse-primary: '#005ac2'
  secondary: '#d0bcff'
  on-secondary: '#3c0091'
  secondary-container: '#571bc1'
  on-secondary-container: '#c4abff'
  tertiary: '#4edea3'
  on-tertiary: '#003824'
  tertiary-container: '#00a572'
  on-tertiary-container: '#00311f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#e9ddff'
  secondary-fixed-dim: '#d0bcff'
  on-secondary-fixed: '#23005c'
  on-secondary-fixed-variant: '#5516be'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#131315'
  on-background: '#e5e1e4'
  surface-variant: '#353437'
  obsidian: '#09090B'
  deep-charcoal: '#18181B'
  glass-surface: '#27272A'
  aura-violet: '#8B5CF6'
  success-emerald: '#10B981'
  warning-amber: '#F59E0B'
  recovery-rose: '#FB7185'
typography:
  display-lg:
    fontFamily: hankenGrotesk
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: hankenGrotesk
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: hankenGrotesk
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
  body-lg:
    fontFamily: inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-mono:
    fontFamily: jetbrainsMono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-max-width: 1200px
  gutter: 24px
  margin-mobile: 20px
  margin-desktop: 40px
  dock-height: 72px
---

## Brand & Style

The design system is built on the philosophy of **Silent Intelligence**. It serves as a sophisticated, high-trust AI companion that prioritizes focus and emotional resonance over the frantic "productivity" metrics of traditional task managers. The aesthetic is atmospheric and deeply personalized, designed to feel like a premium operating system for the self.

The design style is a hybrid of **Minimalism** and **Glassmorphism**. It utilizes a "Dark Mode First" approach, where deep obsidian foundations provide a void-like canvas for luminous AI-driven accents. This creates a sense of depth and hierarchy without the need for heavy borders or high-contrast separation. Every element is refined with Apple-level precision, emphasizing purposeful motion and a mature, empathetic tone.

## Colors

This design system utilizes a palette rooted in deep, light-absorbing neutrals to minimize visual noise. The primary **Discipline Blue** is an intelligent, electric hue used for state indications and primary actions. **Aura Violet** is reserved specifically for AI-driven states, transitions, and "coaching" moments, creating a distinct visual language for the software's intelligence.

Surface colors are built using layers of **Deep Charcoal** with varying levels of transparency to achieve a glassmorphic effect. Accent colors like **Recovery Rose** and **Success Emerald** are used sparingly to provide emotional feedback within the "Empathetic Coach" mode, ensuring that the UI remains calm and high-fidelity even when communicating urgent data.

## Typography

The typography strategy focuses on "breathable" hierarchy. **Hanken Grotesk** provides a sharp, contemporary edge for headlines, offering a technical yet sophisticated feel. **Inter** is used for body copy to ensure maximum legibility and a neutral, systematic tone across all content-heavy areas.

For data-dense environments or "Analyst" states, **JetBrains Mono** is introduced as a secondary accent. This monospaced font signals a shift from emotional coaching to objective behavioral data. Large font sizes are paired with generous line heights to prevent cognitive overload, maintaining the "Spacious" pillar of the brand philosophy.

## Layout & Spacing

This design system uses a **fluid grid** with significant horizontal margins to create a focused, centered column for interaction. The layout is inspired by modern desktop-class applications that utilize a floating navigation model.

- **Floating Dock:** A persistent bottom-dock navigation (80px height) houses the primary behavioral loops.
- **Atmospheric Margins:** Use a 40px margin on desktop to ensure content doesn't feel cramped against the screen edges. 
- **The "Breath" Rule:** Padding inside containers should always exceed the gutter size (minimum 32px) to maintain the "Minimal & Spacious" aesthetic.
- **Vertical Rhythm:** Spacing between sections should be 64px or 80px to clearly delineate different behavioral modules.

## Elevation & Depth

Depth is conveyed through **Glassmorphism** and **Tonal Layers** rather than traditional shadows. Surfaces use a backdrop blur (20px to 40px) and a subtle 1px border (#27272A at 50% opacity) to create a "frosted" separation from the obsidian background.

- **Active States:** Instead of high-elevation shadows, active elements utilize a subtle "outer glow" using a low-opacity version of the Primary or AI accent colors.
- **Z-Axis Hierarchy:** The floating dock sits at the highest level of elevation with the most intense backdrop blur. Cards sit at a mid-level, and the background remains a deep, static void.
- **Luminous Accents:** Soft, large-radius gradients (blobs) may appear behind glass surfaces to indicate focus or AI activity, simulating a sense of "internal light."

## Shapes

The shape language is defined by large, organic radii that feel comfortable and premium. 

- **Primary Cards:** Use a minimum radius of 24px (`rounded-xl` or greater) to reinforce the sophisticated, soft-edged aesthetic.
- **Interactive Elements:** Buttons and input fields follow the `rounded-lg` pattern (16px) for a modern, approachable feel.
- **Aura Rings:** Progress indicators should never be sharp; they use perfectly circular strokes and soft terminal ends to represent the fluid nature of behavioral change.

## Components

### Buttons
- **Primary:** Solid fill with a subtle inner glow. High contrast against the obsidian background.
- **Secondary/Ghost:** Thin 1px border with a glassmorphic background that intensifies on hover.
- **Micro-interactions:** Buttons should feel "tactile" with a slight scale reduction (0.98) on click.

### Glass Cards
Cards are the primary container for behavioral data. They must feature a subtle inner stroke to catch "light" from the top-left, simulating a physical glass material.

### Navigation (The Dock)
A floating, pill-shaped container at the bottom of the viewport. It uses a high-intensity backdrop blur and houses thin-stroke iconography.

### Progress Visualization
Avoid standard progress bars. Use "Aura Rings"—circular progress indicators with soft, glowing gradients—and "Flow Gradients"—linear charts where the line itself is a luminous pulse of color.

### Input Fields
Inputs are border-less glass containers. The active state is indicated by a subtle breathing glow around the perimeter rather than a heavy border color change.

### Iconography
Custom 1.5pt thin-stroke icons. Terminals must be rounded. Icons should feel "weightless" and never be contained in heavy boxes unless they are active.