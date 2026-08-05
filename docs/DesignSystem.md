# Design System Specification — Finora

## 📌 1. Document Metadata
* **Document Version**: v1.1.0
* **Status**: Baseline Design System Standard
* **Owner**: UX Architect & Design System Lead
* **Audience**: UI/UX Designers, Frontend Flutter Engineers, QA Specialists, and AI Coding Assistants.
* **Review Cycle**: Semi-annually or upon major core widget upgrades.

---

## 🎨 2. Design Philosophy

Finora's design language is built on trust, clarity, and control. When users manage their personal or business finances, they should feel calm, in control, and confident in the reliability of the system.

* **Simplicity**: Financial software is often cluttered with micro-data. Finora prioritizes essential numbers, removing visual noise.
* **Clarity**: High visual contrast, readable typography, and structured hierarchy ensure that balances, budget limits, and transaction flows are instantly understandable.
* **Trust**: A professional, structured aesthetic with clean geometric shapes, muted tones, and steady layouts communicates technical and financial stability.
* **Financial Confidence**: We avoid chaotic accents or overly saturated gamification elements. The UI respects the user's focus.
* **Consistency**: Shared components and layout systems ensure that interaction patterns remain identical across all screens.
* **Accessibility**: Financial management is a fundamental utility. The design must accommodate diverse visual, motor, and cognitive needs.
* **Calm Interfaces**: High whitespace ratios and gentle transitions help reduce money-management anxiety.
* **Minimal Cognitive Load**: Design with smart defaults and progressive disclosures. Never overwhelm the user with all options at once.

---

## 📐 3. Design Principles

1. **Consistency**: Use identical patterns, margins, actions, and states across the entire application. If a transaction detail opens in a bottom sheet on one screen, it must not open in a full-screen route on another.
2. **Predictability**: Interactions must match user expectations. Swiping a card left should consistently trigger an archive or delete action.
3. **Progressive Disclosure**: Show key info first (e.g., total balance, budget status), then allow users to dive deeper (e.g., granular charts, full log history).
4. **Visual Hierarchy**: Guide the eye with layout size, font weight, contrast, and distance. The primary balance is always the most dominant element on the dashboard.
5. **Recognition Over Recall**: Do not make users remember previous actions. Use clear icons, context tags, and auto-populated default fields.
6. **Accessibility**: Colors must pass contrast checks, targets must be large enough to touch easily, and fonts must scale gracefully.
7. **Responsive Design**: The interface must adapt cleanly to different screen sizes without losing context or functionality.

---

## 🌈 4. Color Philosophy

We do not dictate exact hexadecimal values here. Instead, we establish the semantic roles and psychological principles for the color system:

* **Primary**: The main brand color (typically a professional sapphire or deep navy). It represents stability, reliability, and security. Used for primary call-to-action (CTA) buttons, selection states, and focus borders.
* **Secondary**: A supportive, calming tone (such as slate grey or cool teal) that provides subtle visual accents without distracting from primary tasks.
* **Surface**: The canvas and containment areas. Surface containers must use varying elevations or background tints to structure the screen's visual hierarchy cleanly.
* **Error**: A clear, semantic crimson or coral tone. It indicates destructive actions, field errors, or budget limits exceeded.
* **Success**: A steady green tint representing successful operations, completed goals, and positive financial balances.
* **Warning**: A warm amber or mustard hue indicating warning thresholds (e.g., reaching 80% of a budget limit).
* **Income**: Visually distinct green (different from Success) highlighting money flowing into a wallet.
* **Expense**: Visually distinct red (different from Error) highlighting money flowing out of a wallet.
* **Neutral**: Tints of grey, black, and white used for background canvas, text hierarchy, and secondary icons.

---

## 🔤 5. Typography

The type system prioritizes readability, structured hierarchy, and tabular numerical layout compatibility:

* **Display**: Large, high-impact styles. Used for heroic numbers (e.g., master wallet balance display). Must use a font family that supports clean, non-proportional tabular figures so currency values do not dance as the numbers change.
* **Headlines**: Medium-to-large sizes. Used for page titles and main category summaries.
* **Titles**: Medium-sized, high-contrast styles. Used for card headings, list sections, and dialog headers.
* **Body**: Regular font weights with optimized line heights. Used for transaction descriptions, form inputs, metadata details, and standard text blocks.
* **Labels**: Small styles. Used for buttons, chips, table headers, and category tags.

---

## 📏 6. Spacing System

We utilize a strict **8dp (density-independent pixels) spacing grid** to maintain vertical rhythm, layout predictability, and elegant whitespace:

* **Grid Increments**: 4dp (extra-small), 8dp (small), 16dp (medium/standard edge padding), 24dp (large), 32dp (extra-large), 48dp (double-large).
* **Margins**: Standard screen margin padding is **16dp**. Use 24dp for larger devices (Tablets/Desktop).
* **Padding**: Cards and list tiles use 12dp or 16dp inner padding.
* **Vertical Rhythm**: Ensure structural blocks are separated by multiples of 8dp. Text line heights must align to the grid to prevent awkward vertical spacing.
* **White Space**: Generous whitespace is a functional feature. It reduces visual clutter, guides focus, and makes the app feel premium and calm.

---

## 🧱 7. Component Philosophy

Every UI component has a dedicated functional role. Follow these expectations for their usage:

* **Buttons**:
  - *Primary*: High-contrast filled button for the single most important action on a screen (e.g., "Add Transaction").
  - *Secondary*: Outlined or tonal button for supportive actions (e.g., "Cancel", "Filter").
  - *Text*: Frameless button for inline links or minor options.
* **Cards**: Elevate content modules cleanly. Use flat surface cards with a subtle border for list items, and slightly elevated/colored cards for high-level summaries.
* **Dialogs**: Interruptive modals used ONLY for critical decisions requiring explicit user confirmation (e.g., deleting an account, data reset).
* **Bottom Sheets**: Slide-up panels used for secondary screen forms, detail views, or selection menus (e.g., category pickers). They preserve screen context.
* **Text Fields**: Clean containers with clear labels, focus borders, and inline helper/error indicators. Must support localized numeric formatting for currency input fields.
* **Search**: Persistent, high-contrast search bar on logs, supporting inline suggestion chips and fast query clearance.
* **Navigation**: Single navigation shell (bottom navigation on mobile, side rail on tablet/desktop) with clear visual indicators for active states.
* **Lists**: Smooth scrolling, high-readability lists with clean dividers, descriptive headers, and responsive swipe-to-reveal gesture indicators.
* **Charts**: Minimalist lines and bars, prioritizing clean data legends over complex 3D rendering.
* **Badges**: Small numeric overlays indicating status updates or pending sync alerts.
* **Chips**: Filter tokens that users can tap to filter list feeds quickly without typing.
* **Snackbars**: Low-priority, auto-dismissing notifications at the bottom of the screen to confirm non-destructive operations (e.g., "Transaction saved"). Must offer an "Undo" action.
* **Floating Action Button (FAB)**: Prominent action button used only on the primary dashboard to initiate the most common user workflow (e.g., logging a transaction).

---

## 🎨 8. Iconography

* **Icon Consistency**: Select a single unified icon pack (such as Material Symbols Outlined). Never mix organic rounded icons with geometric, sharp-edged icon families.
* **Filled vs Outlined**: Use outlined icons for standard inactive buttons and list items. Use filled versions exclusively to indicate active or selected states.
* **Financial Semantics**: Use consistent semantic icons: green upward arrows for income, red downward arrows for expenses, and purple horizontal/circular arrows for internal transfers.

---

## 🎬 9. Motion & Animation

* **Meaningful Animation**: Every transition must explain a state change. A modal sliding up from the bottom indicates a contextual sub-flow. A list item sliding left indicates deletion.
* **Motion Performance**: Animations must be short (150ms to 300ms) with clean easing curves (ease-out or cubic-bezier) to prevent sluggish perceived latency.
* **Zero Distraction**: Avoid bouncing, spinning, or heavy entrance animations. Motion must serve a functional purpose, not decorate a screen.
* **Reduced Motion**: Respect device system preferences for reduced motion by disabling non-essential transitions when requested.

---

## 📭 10. Empty States

Empty states are learning opportunities, not dead-ends.
- Never show a blank screen.
- Include a supportive illustration, a friendly localized title explaining *why* the screen is empty, and a clear call-to-action button (e.g., "Create your first category" or "Add a transaction").

---

## ⏳ 11. Loading States

- **Perceived Performance**: Show skeleton loaders that match the layout shape of incoming data cards, preventing jumpy page layout transitions.
- **Progress Indicators**: Use small, circular progress bars for minor actions (e.g., syncing a single item) and linear indicators for background uploads.

---

## 🚫 12. Error States

- **Friendly Tone**: Explain what went wrong in plain, non-technical language. Never show raw database queries or exception traces in user dialogs.
- **Helpful & Actionable**: Always provide a path to recovery (e.g., a "Retry" button or "Validate credentials" link).
- **Never Blame**: Language must be neutral. Use "Incorrect format" instead of "You entered the wrong amount."

---

## ♿ 13. Accessibility Standards

- **Contrast**: Text elements must satisfy WCAG AA standards (4.5:1 ratio for standard text, 3:1 for large display headers).
- **Touch Targets**: Minimum interactive dimension is **48x48dp** to accommodate all users comfortably.
- **Text Scaling**: Layouts must use flexible grids and expand gracefully when the user adjusts their system font size.
- **Color Blindness**: Never communicate state via color alone. Budget status must use text labels or progress icons in addition to color indicators.
- **RTL Support**: Use relative navigation anchors (start/end instead of left/right) to ensure full right-to-left localization support.

---

## 📱 14. Responsive Design & Multi-Platform Adaptation

* **Phones**: Main interface optimized for single-handed usage. Keep common CTAs at the bottom of the screen.
* **Tablets & Foldables**: Transition from a single-column layout to split-pane interfaces (list of transactions on the left, transaction details permanently open on the right).
* **Landscape Mode**: Adapt layout grids to prevent scrolling overload. Expand input fields horizontally.
* **Future Desktop Support**: Navigation shifts to a persistent left-side navigation rail, utilizing wider spacing paradigms.

---

## 📊 15. Financial Data Visualization

* **Pie Charts**: Used only for broad category expense distributions. Capped at 5 segments; smaller slices must be grouped into an "Others" category.
* **Bar & Line Charts**: Timelines showing financial trends. Keep gridlines clean and labels minimal. Tabular numbers must line up cleanly on axis markers.
* **Budget Progress Bars**: Clear fill indicator with semantic color thresholds: green for safe, amber for approaching limit, and red for over-budget.
* **Net Worth Over Time**: Clean line chart with shaded area fill underneath. Remove grid clutter.

---

## 🌙 16. Dark Mode Philosophy

- **OLED Comfort**: Dark mode must use deep charcoal tints (`Elevation 0`) and elevated surfaces (`Elevation 1` and `Elevation 2`) to separate cards, rather than pure black overlays.
- **Readability**: Adjust font weights or color opacity slightly in dark mode to prevent visual glow and text bleeding.
- **Contrast Security**: Verify semantic income/expense colors pass contrast checks on dark surfaces.

---

## 🧠 17. UX Principles for Financial Logging

* **Reduce User Effort**: Log a transaction in 3 steps or less. The numeric keyboard should automatically focus on entry page launch.
* **One-Handed Layouts**: Place input forms and bottom sheet buttons within comfortable reach of a user's thumb.
* **Smart Defaults**: Auto-select the current date, active account, and last-used categories to minimize repetitive typing.
* **Undo Pattern**: Confirm deletions via a simple undo toast notification instead of showing an interruptive "Are you sure?" modal for every routine action.

---

## 🔮 18. Future Evolution

As Finora evolves from V1 to V2, the Design System remains consistent by utilizing tokenized theme extensions. All visual updates must be proposed via design ADRs and validated across responsive layouts before component modifications are baseline approved.
