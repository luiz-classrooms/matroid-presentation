// ============================================================================
// Matroid Theory from First Principles and Its Role in Greedy Algorithms
// A slide presentation in Typst
//
// Compile with:  typst compile matroid_theory_greedy_algorithms.typ
//
// Structure:
//   Part I   – Motivation
//   Part II  – First Principles (axioms, examples)
//   Part III – Bases, Rank, Circuits, Closure
//   Part IV  – Greedy Algorithms and Matroids
//   Part V   – Classical Examples
//   Part VI  – Minimum Spanning Trees
//   Part VII – Beyond MSTs
//   Part VIII– Summary and References
// ============================================================================

// ─── Page setup ──────────────────────────────────────────────────────────────
#set page(
  paper: "a4",
  flipped: true,
  margin: (top: 1.8cm, bottom: 0.8cm, left: 1.2cm, right: 1.2cm),
  background: rect(fill: white, width: 100%, height: 100%),
)

#set text(font: ("Libertinus Serif", "New Computer Modern"), size: 12pt, fill: rgb("#334155"))
#set par(justify: false, leading: 0.6em)

// ─── Colour palette ──────────────────────────────────────────────────────────
#let dark-blue = rgb("#1a2e4a")
#let mid-blue = rgb("#2563a8")
#let light-blue = rgb("#dbeafe")
#let gold = rgb("#d4a017")
#let gold-light = rgb("#fef3c7")
#let green = rgb("#166534")
#let green-light = rgb("#dcfce7")
#let red-dark = rgb("#991b1b")
#let red-light = rgb("#fee2e2")
#let light-gray = rgb("#f1f5f9")
#let med-gray = rgb("#94a3b8")
#let dark-gray = rgb("#334155")
#let code-bg = rgb("#1e293b")
#let code-fg = rgb("#e2e8f0")

// ─── Reusable macros ─────────────────────────────────────────────────────────

// Header bar for each slide
#let slide-header(title, part-label: none) = {
  block(
    width: 100%,
    fill: dark-blue,
    inset: (x: 10pt, y: 8pt),
    radius: (top-left: 6pt, top-right: 6pt),
    below: 0pt,
  )[
    #if part-label != none [
      #text(fill: gold, size: 9pt, weight: "bold")[#part-label] \
    ]
    #text(fill: white, size: 18pt, weight: "bold")[#title]
  ]
  // Gold accent stripe
  block(width: 100%, height: 3pt, fill: gold, below: 8pt)
}

// Definition box
#let defn-box(title, body-content) = block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1.2pt),
  inset: 10pt,
  radius: 5pt,
  below: 8pt,
)[
  #text(fill: mid-blue, weight: "bold")[Definition: #title] \
  #body-content
]

// Theorem box
#let thm-box(title, body-content) = block(
  width: 100%,
  fill: gold-light,
  stroke: (paint: gold, thickness: 1.2pt),
  inset: 10pt,
  radius: 5pt,
  below: 8pt,
)[
  #text(fill: gold, weight: "bold")[Theorem: #title] \
  #body-content
]

// Example box
#let ex-box(title, body-content) = block(
  width: 100%,
  fill: green-light,
  stroke: (paint: green, thickness: 1.2pt),
  inset: 10pt,
  radius: 5pt,
  below: 8pt,
)[
  #text(fill: green, weight: "bold")[Example: #title] \
  #body-content
]

// Non-example / warning box
#let warn-box(title, body-content) = block(
  width: 100%,
  fill: red-light,
  stroke: (paint: red-dark, thickness: 1.2pt),
  inset: 10pt,
  radius: 5pt,
  below: 8pt,
)[
  #text(fill: red-dark, weight: "bold")[Non-Example: #title] \
  #body-content
]

// Info / highlight box
#let info-box(body-content) = block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1pt),
  inset: 10pt,
  radius: 5pt,
  below: 8pt,
)[#body-content]

// Pseudocode block
#let code-block(code-text) = block(
  width: 100%,
  fill: code-bg,
  stroke: (paint: med-gray, thickness: 0.8pt),
  inset: 10pt,
  radius: 4pt,
  below: 8pt,
)[
  #text(fill: code-fg, font: "Fira Code", size: 10pt)[
    #code-text
  ]
]

// Bullet items
#let bul(content) = [• #content \ ]
#let bul2(content) = [#h(1.5em) – #content \ ]

// Math display
#let mth(content) = block(inset: (left: 1.5em), below: 4pt)[
  #emph(content)
]

// Two-column layout
#let two-col(left, right, left-frac: 50%) = {
  let right-frac = (100% - left-frac)
  grid(
    columns: (left-frac, right-frac),
    gutter: 1em,
    left, right,
  )
}

// Part divider slide
#let part-slide(number, title, subtitle) = {
  page(background: rect(fill: dark-blue, width: 100%, height: 100%))[
    #align(center + horizon)[
      #text(fill: gold, size: 14pt, weight: "bold")[Part #number]
      #v(0.5em)
      #text(fill: white, size: 28pt, weight: "bold")[#title]
      #v(0.3em)
      #text(fill: med-gray, size: 16pt)[#subtitle]
    ]
  ]
}

// ─── Page footer macro ───────────────────────────────────────────────────────
#let footer-bar = place(bottom)[
  #block(width: 100%, height: 18pt, fill: dark-blue, inset: (x: 10pt, y: 3pt))[
    #text(fill: med-gray, size: 7pt)[
      Matroid Theory & Greedy Algorithms
      #h(1fr)
      #context counter(page).display()
    ]
  ]
]

// ============================================================================
// SLIDE 1: Title Slide
// ============================================================================
#page(background: rect(fill: dark-blue, width: 100%, height: 100%))[
  #align(center + horizon)[
    #text(fill: white, size: 34pt, weight: "bold")[Matroid Theory] \
    #v(0.2em)
    #text(fill: med-gray, size: 16pt)[from First Principles & Its Role in Greedy Algorithms]
    #v(0.8em)
    #line(length: 55%, stroke: (paint: gold, thickness: 2pt))
    #v(0.5em)
    #text(fill: rgb("#93c5fd"), size: 13pt)[
      A rigorous yet accessible introduction \
      for advanced undergraduates and early graduate students
    ]
    #v(1em)
    #text(fill: med-gray, size: 10pt)[
      Topics: Matroid Axioms · Greedy Theorem · Graphic Matroids · MST Algorithms
    ]
  ]
]

// ============================================================================
// PART I: Motivation
// ============================================================================
#part-slide("I", "Motivation", "Why do some greedy algorithms work — and others fail?")

// ─── Slide: The Central Question ─────────────────────────────────────────────
#footer-bar
#slide-header("The Central Question: When Does Greedy Work?", part-label: "Part I — Motivation")

#block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1.5pt),
  inset: 14pt,
  radius: 6pt,
  below: 10pt,
)[
  #align(center)[
    #text(size: 15pt, weight: "bold", fill: dark-blue)[
      When does greedily choosing the locally best option yield a globally optimal solution?
    ]
  ]
]

#bul[Greedy algorithms are simple, fast, and elegant.]
#bul[But they are _not always correct_.]
#bul[*Matroids* reveal exactly when and why greedy is provably optimal.]
#v(0.5em)
#info-box[
  Answer: The greedy algorithm finds a maximum-weight solution for _every_ weight function
  *if and only if* the feasible sets form a matroid.
]

#pagebreak()

// ─── Slide: Greedy Success ────────────────────────────────────────────────────
#footer-bar
#slide-header("A Greedy Success: Select the k Largest Items", part-label: "Part I — Motivation")

*Problem:* Choose at most $k$ items from a set to maximise total value.

#ex-box("Greedy Works!")[
  Items with values $\{9, 5, 3, 1\}$, $k = 2$. \
  Greedy: pick $9$, then $5$. Total $= 14$. This is optimal.
]

*Why does greedy work here?*
#bul[Any subset of size $lt.eq k$ is feasible.]
#bul[If our set has fewer than $k$ items and a better unused item exists, we can freely add it.]
#bul[No feasibility constraint ever _blocks_ a greedy choice.]
#bul2[This is the *uniform matroid* in disguise — we will formalise it shortly.]

#pagebreak()

// ─── Slide: Greedy Failure ────────────────────────────────────────────────────
#footer-bar
#slide-header("A Greedy Failure: 0/1 Knapsack", part-label: "Part I — Motivation")

*Problem:* Capacity $= 10$. Greedy by value/weight ratio:

#table(
  columns: (auto, auto, auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-gray },
  table.header(
    text(fill: white)[*Item*], text(fill: white)[*Weight*], text(fill: white)[*Value*], text(fill: white)[*Val/Wt*]
  ),
  [A], [6], [12], [2.0],
  [B], [5], [9], [1.8],
  [C], [5], [9], [1.8],
)

#warn-box("Greedy by ratio fails!")[
  Greedy picks $A$ (weight 6), then cannot fit $B$ or $C$. Total value $= 12$. \
  Optimal: $B + C$ (weight $= 10$, value $= 18$).
]

#bul[The feasible sets $\{S : "weight"(S) ≤ 10\}$ do *not* form a matroid.]
#bul[The *exchange axiom* fails — this is why greedy breaks.]

#pagebreak()

// ─── Slide: Independence abstraction ─────────────────────────────────────────
#footer-bar
#slide-header("Independence: The Common Abstraction", part-label: "Part I — Motivation")

Both examples involve a collection of _feasible subsets_. The key is their structure:

#table(
  columns: (auto, auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-blue },
  table.header(
    text(fill: white)[*Setting*], text(fill: white)[*Ground Set E*], text(fill: white)[*Independent Sets I*]
  ),
  [Choose $≤ k$ items], [Items], [Subsets of size $≤ k$],
  [Linear algebra], [Vectors], [Linearly independent subsets],
  [Graph theory], [Edges], [Acyclic edge sets (forests)],
  [Scheduling], [Jobs], [Feasible job subsets],
)

#v(0.5em)
#info-box[
  A *matroid* $M = (E, cal(I))$ abstracts precisely the structure shared by all of these —
  enabling a single unified proof of greedy correctness.
]

#pagebreak()

// ============================================================================
// PART II: First Principles
// ============================================================================
#part-slide("II", "First Principles", "Defining matroids from axioms")

// ─── Slide: Definition ───────────────────────────────────────────────────────
#footer-bar
#slide-header("Definition of a Matroid", part-label: "Part II — First Principles")

#defn-box("Matroid  $M = (E, cal(I))$")[
  A *matroid* is a pair $M = (E, cal(I))$ where $E$ is a finite set and
  $cal(I) ⊆ 2^E$ satisfies: \

  *(I1) Non-emptiness:* $∅ ∈ cal(I)$ \
  *(I2) Heredity:* If $A ∈ cal(I)$ and $B ⊆ A$, then $B ∈ cal(I)$ \
  *(I3) Exchange:* If $A, B ∈ cal(I)$ and $|A| < |B|$,
  then $∃ x ∈ B ∖ A$ such that $A ∪ \{x\} ∈ cal(I)$
]

#bul[Elements of $cal(I)$ are called *independent*; others are *dependent*.]
#bul[$E$ is the *ground set*. Examples: columns of a matrix, edges of a graph, items in a set.]

#table(
  columns: (auto, auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-blue },
  table.header(text(fill: white)[*Axiom*], text(fill: white)[*Name*], text(fill: white)[*Informal Meaning*]),
  [(I1)], [Non-emptiness], [Choosing nothing is always feasible],
  [(I2)], [Heredity], [Subsets of feasible sets are feasible],
  [(I3)], [Exchange], [Smaller independent sets can be augmented],
)

#pagebreak()

// ─── Slide: Axiom I1 ─────────────────────────────────────────────────────────
#footer-bar
#slide-header("Axiom (I1): Non-Emptiness", part-label: "Part II — First Principles")

#block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1.5pt),
  inset: 14pt,
  radius: 6pt,
  below: 10pt,
)[
  #align(center)[#text(size: 15pt, weight: "bold", fill: mid-blue)[(I1)  The empty set is independent: $∅ ∈ cal(I)$]]
]

*Interpretation:*
#bul[Choosing nothing is always feasible — a base case for building independent sets.]
#bul[Without (I1), we could not guarantee any solution exists.]

*In each setting:*
#bul[*Vectors:* The empty set of vectors is trivially linearly independent.]
#bul[*Edges:* The empty edge set is a trivially acyclic forest.]
#bul[*Selection:* Choosing zero items satisfies any cardinality bound.]

#pagebreak()

// ─── Slide: Axiom I2 ─────────────────────────────────────────────────────────
#footer-bar
#slide-header("Axiom (I2): Heredity (Downward Closure)", part-label: "Part II — First Principles")

#block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1.5pt),
  inset: 14pt,
  radius: 6pt,
  below: 10pt,
)[
  #align(center)[#text(size: 15pt, weight: "bold", fill: mid-blue)[
    (I2)  If $A ∈ cal(I)$ and $B ⊆ A$, then $B ∈ cal(I)$
  ]]
]

*Interpretation:* Subsets of independent sets are independent. Independence is _downward-closed_.

*In each setting:*
#bul[*Vectors:* Any subset of linearly independent vectors is linearly independent.]
#bul[*Edges:* Any subset of an acyclic edge set is also acyclic.]
#bul[*Selection:* If choosing $k$ items is feasible, choosing fewer is also feasible.]

#warn-box("The Knapsack feasible system violates heredity!")[
  Feasible sets are $\{S : "weight"(S) ≤ 10\}$. Suppose $\{B, C\}$ is feasible
  but $\{A, B, C\}$ is not. Yet individually $A$ has weight $6 ≤ 10$.
  The issue: adding $A$ to $\{B, C\}$ _exceeds_ capacity, so $\{A,B,C\} ∉ cal(I)$.
  The downward-closure property _does_ hold here individually, but exchange fails.
]

#pagebreak()

// ─── Slide: Axiom I3 ─────────────────────────────────────────────────────────
#footer-bar
#slide-header("Axiom (I3): Exchange (Augmentation) — The Key Axiom", part-label: "Part II — First Principles")

#block(
  width: 100%,
  fill: light-blue,
  stroke: (paint: mid-blue, thickness: 1.5pt),
  inset: 14pt,
  radius: 6pt,
  below: 8pt,
)[
  #align(center)[#text(size: 14pt, weight: "bold", fill: mid-blue)[
    (I3)  If $A, B ∈ cal(I)$ and $|A| < |B|$,
    then $∃ x ∈ B ∖ A$ such that $A ∪ \{x\} ∈ cal(I)$
  ]]
]

*Interpretation:* Any smaller independent set can be _augmented_ from a larger one.
#bul[We can always "fill up" a small independent set using elements of a bigger one.]
#bul[This is the *heart of greedy correctness* — we prove this formally in Part IV.]
#bul[In linear algebra: if $dim(A) < dim(B)$, we can find a vector in $B$ not in $"span"(A)$.]

*Why this matters algorithmically:*
#bul2[Exchange prevents greedy from reaching a "dead end" — a locally maximal but globally sub-optimal solution.]
#bul2[It implies all maximal independent sets (bases) have equal size — no "accidentally small" solutions.]

#pagebreak()

// ─── Slide: Uniform Matroid ───────────────────────────────────────────────────
#footer-bar
#slide-header("Uniform Matroids $U_{k,n}$", part-label: "Part II — First Principles")

#defn-box("Uniform Matroid $U_{k,n}$")[
  Ground set: $E = \{1, 2, …, n\}$. \
  Independent sets: $cal(I) = \{ A ⊆ E : |A| ≤ k \}$.
]

#ex-box("$U_{2,4}$ — $E = \\{a, b, c, d\\}$, $k = 2$")[
  $cal(I)$ = $\{∅, \{a\}, \{b\}, \{c\}, \{d\}, \{a,b\}, \{a,c\}, \{a,d\}, \{b,c\}, \{b,d\}, \{c,d\}\}$ \
  Dependent sets: $\{a,b,c\}, \{a,b,d\}, \{a,c,d\}, \{b,c,d\}, \{a,b,c,d\}$
]

*Axiom verification:*
#bul[(I1) $∅ ∈ cal(I)$ since $|∅| = 0 ≤ k$. ✓]
#bul[(I2) If $|A| ≤ k$ and $B ⊆ A$, then $|B| ≤ |A| ≤ k$. ✓]
#bul[(I3) If $|A| < |B| ≤ k$, pick any $x ∈ B ∖ A$.  Then $|A ∪ \{x\}| = |A|+1 ≤ |B| ≤ k$. ✓]

#bul[*Greedy on $U_{k,n}$:* simply select the $k$ highest-weight elements. Trivially optimal.]

#pagebreak()

// ─── Slide: Linear Matroid ────────────────────────────────────────────────────
#footer-bar
#slide-header("Linear Matroids", part-label: "Part II — First Principles")

#defn-box("Linear Matroid")[
  Let $bb(F)$ be a field, $A$ an $m × n$ matrix over $bb(F)$. \
  Ground set: $E = \{1, …, n\}$ (column indices). \
  Independent sets: $cal(I) = \{ S ⊆ E : "columns indexed by " S " are linearly independent" \}$.
]

#ex-box([Over $bb(R)$])[
  $A = mat(1, 0, 1; 0, 1, 1)$.
  Columns: $v_1 = (1,0)$, $v_2 = (0,1)$, $v_3 = (1,1)$. \
  Independent: $\{1\}, \{2\}, \{3\}, \{1,2\}, \{1,3\}, \{2,3\}$. \
  Dependent: $\{1,2,3\}$ since $v_3 = v_1 + v_2$.
]

#bul[Exchange axiom $↔$ the linear-algebra augmentation lemma for bases.]
#bul[Rank of matroid $=$ column rank of $A$.]
#bul[Used in: network coding, VLSI, maximum-weight closure, matching in bipartite graphs.]

#pagebreak()

// ─── Slide: Graphic Matroid ───────────────────────────────────────────────────
#footer-bar
#slide-header("Graphic Matroids $M(G)$", part-label: "Part II — First Principles")

#defn-box("Graphic Matroid $M(G)$")[
  Let $G = (V, E)$ be an undirected graph. \
  Ground set: $E$ (edges of $G$). \
  Independent sets: $cal(I) = \{ F ⊆ E : (V, F) " is a forest (acyclic)" \}$.
]

*Structure:*
#bul[Bases $=$ spanning forests; in connected $G$: bases $=$ spanning trees (each with $|V|-1$ edges).]
#bul[Circuits $=$ simple cycles of $G$.]
#bul[Rank: $r(F) = |V| - ("number of connected components of " (V,F))$.]

*Axiom verification:*
#bul[(I1) Empty edge set is an acyclic forest. ✓]
#bul[(I2) Any subset of an acyclic edge set is acyclic. ✓]
#bul[(I3) Two forests $F_1, F_2$ with $|F_1| < |F_2|$: $F_2$ has fewer components, so some edge of $F_2$ connects two components of $F_1$ — adding it stays acyclic. ✓]

#pagebreak()

// ─── Slide: Non-example ──────────────────────────────────────────────────────
#footer-bar
#slide-header("A Non-Example: Failure of the Exchange Axiom", part-label: "Part II — First Principles")

#warn-box("Non-matroid: mismatched maximal sets")[
  $E = \{a, b, c\}$, $cal(I) = \{∅, \{a\}, \{b,c\}\}$. \
  Both $\{a\}$ and $\{b,c\}$ are maximal (cannot add any element). \
  But $|\{a\}| = 1 ≠ 2 = |\{b,c\}|$. \
  Exchange fails: from $\{b,c\}$, we cannot augment $\{a\}$ — $\{a,b\} ∉ cal(I)$ and $\{a,c\} ∉ cal(I)$.
]

#thm-box("Diagnostic")[
  If (I3) fails, there exist weights making greedy suboptimal. \
  *Proof:* Assign $w(a) = 5$, $w(b) = w(c) = 3$. \
  Greedy picks $\{a\}$ (value 5). But $\{b,c\}$ has value 6. Greedy fails.
]

#info-box[
  *Key lesson:* Always verify all three matroid axioms before trusting a greedy algorithm.
  Failing (I3) is both necessary and sufficient for greedy to break on some weight function.
]

#pagebreak()

// ============================================================================
// PART III: Bases, Rank, Circuits, Closure
// ============================================================================
#part-slide("III", "Structure", "Bases · Rank · Circuits · Closure")

// ─── Slide: Bases ─────────────────────────────────────────────────────────────
#footer-bar
#slide-header("Bases", part-label: "Part III — Structure")

#defn-box("Basis")[
  A *basis* of $M = (E,cal(I))$ is a maximal independent set: $B ∈ cal(I)$ such that
  $B ∪ \{e\} ∉ cal(I)$ for all $e ∈ E ∖ B$. \
  The collection of all bases is denoted $cal(B)(M)$.
]

#thm-box("Equal Cardinality of Bases")[
  All bases of a matroid have the same cardinality. \
  *Proof sketch:* Suppose $|B_1| < |B_2|$. By (I3), $∃ e ∈ B_2 ∖ B_1$
  with $B_1 ∪ \{e\} ∈ cal(I)$, contradicting maximality of $B_1$. ∎
]

*Examples:*
#bul[$U_{k,n}$: all bases have size exactly $k$.]
#bul[Linear matroid on $A$: bases are maximal linearly independent column sets — all have size $= "rank"(A)$.]
#bul[Graphic matroid on connected $G$: bases $=$ spanning trees, all of size $|V|-1$.]

#pagebreak()

// ─── Slide: Rank ─────────────────────────────────────────────────────────────
#footer-bar
#slide-header("Rank Function", part-label: "Part III — Structure")

#defn-box([Rank  $r : 2^E → bb(Z)_(≥ 0)$])[
  For $A ⊆ E$: $r(A) = max\{|I| : I ∈ cal(I),\ I ⊆ A\}$. \
  The *rank of the matroid* is $r(E)$.
]

*Key properties:*
#bul[(R1) $0 ≤ r(A) ≤ |A|$]
#bul[(R2) Monotone: $A ⊆ B ⇒ r(A) ≤ r(B)$]
#bul[(R3) *Submodular*: $r(A ∪ B) + r(A ∩ B) ≤ r(A) + r(B)$]

*In specific matroids:*
#bul[$U_{k,n}$: $r(A) = min(|A|, k)$.]
#bul[Linear matroid: $r(A) =$ column rank of the submatrix with columns in $A$.]
#bul[Graphic matroid: $r(F) = |V| - c(F)$ where $c(F)$ = number of connected components.]

#pagebreak()

// ─── Slide: Circuits ─────────────────────────────────────────────────────────
#footer-bar
#slide-header("Circuits", part-label: "Part III — Structure")

#defn-box("Circuit")[
  A *circuit* is a minimal dependent set: $C ⊆ E$ with $C ∉ cal(I)$
  but $C ∖ \{e\} ∈ cal(I)$ for every $e ∈ C$. \
  The collection of all circuits is $cal(C)(M)$.
]

#two-col(
  [
    *In graphic matroids:*
    #bul[Circuits $=$ simple cycles of $G$.]
    #bul[Adding any edge to a spanning tree creates exactly one circuit.]
    #bul[Cycle property: the heaviest edge in any cycle belongs to no MST.]

    #ex-box("")[
      Path $1{-}2{-}3{-}1$ is a circuit. Removing any edge yields an acyclic (independent) set.
    ]
  ],
  [
    *Circuit properties:*
    #bul[No circuit is a subset of another: $cal(C)(M)$ is an antichain.]
    #bul[*Circuit elimination:* If $C_1, C_2 ∈ cal(C)(M)$ and $e ∈ C_1 ∩ C_2$, then $∃ C_3 ∈ cal(C)(M)$ with $C_3 ⊆ (C_1 ∪ C_2) ∖ \{e\}$.]
    #bul[Matroids can be axiomatised via circuits equivalently.]
  ],
)

#pagebreak()

// ─── Slide: Closure ──────────────────────────────────────────────────────────
#footer-bar
#slide-header("Closure (Span)", part-label: "Part III — Structure")

#defn-box([Closure  $"cl" : 2^E -> 2^E$])[
  $"cl"(A) = \{ e ∈ E : r(A ∪ \{e\}) = r(A) \}$. \
  Equivalently: $e ∈ "cl"(A)$ iff adding $e$ to $A$ does not increase rank.
]

*Intuition:*
#bul[$"cl"(A)$ is the "span" of $A$ — all elements already "dependent" on $A$.]
#bul[Linear matroids: $"cl"(A) = \{$vectors in $E$ lying in $"span"(A)\}$.]
#bul[Graphic matroids: $"cl"(F) = F ∪ \{$edges whose endpoints are connected in $(V,F)\}$.]

*Closure axioms (alternative axiom system for matroids):*
#bul[(CL1) $A ⊆ "cl"(A)$]
#bul[(CL2) $A ⊆ B ⇒ "cl"(A) ⊆ "cl"(B)$]
#bul[(CL3) $"cl"("cl"(A)) = "cl"(A)$]
#bul[(CL4) *Mac Lane–Steinitz:* $e ∉ "cl"(A)$ and $e ∈ "cl"(A ∪ \{f\}) ⇒ f ∈ "cl"(A ∪ \{e\})$]

#pagebreak()

// ============================================================================
// PART IV: Greedy Algorithms and Matroids
// ============================================================================
#part-slide("IV", "Greedy Algorithms & Matroids", "The central theorem and its proof")

// ─── Slide: Generic greedy ───────────────────────────────────────────────────
#footer-bar
#slide-header("The Generic Greedy Algorithm for Matroids", part-label: "Part IV — Greedy Algorithms")

#code-block[
  GREEDY(M = (E, I), w : E → ℝ):\
  Sort elements: e₁, e₂, ..., eₙ  with  w(e₁) ≥ w(e₂) ≥ ... ≥ w(eₙ)\
  S ← ∅\
  for i = 1 to n do:\
  if  S ∪ {eᵢ} ∈ I  then\
  S ← S ∪ {eᵢ}\
  return S
]

*Properties:*
#bul[Time: $O(n log n)$ for sorting + $n$ independence oracle calls.]
#bul[Correctness: holds *if and only if* $(E, cal(I))$ is a matroid.]
#bul[Independence oracle examples:]
#bul2[$U_{k,n}$: check $|S| < k$. $O(1)$.]
#bul2[Graphic: check cycle via Union-Find. $O(α(n))$ amortised.]
#bul2[Linear: check rank via Gaussian elimination. $O(n^2)$.]

#pagebreak()

// ─── Slide: Matroid greedy theorem ───────────────────────────────────────────
#footer-bar
#slide-header("The Matroid Greedy Theorem", part-label: "Part IV — Greedy Algorithms")

#thm-box("Matroid Greedy Theorem (Edmonds, 1971)")[
  Let $(E, cal(I))$ be an independence system (satisfying I1 and I2).
  The greedy algorithm finds a maximum-weight basis for *every* weight function
  $w : E → bb(R)_{≥ 0}$ *if and only if* $(E, cal(I))$ is a matroid.
]

*Proof sketch ($⇒$) — matroids make greedy optimal:*
#bul[Suppose greedy output $S$ is suboptimal; let OPT be a better solution.]
#bul[Find the first weight-rank position where they diverge: greedy chose $s_i$, OPT has $o_i$ with $w(o_i) ≥ w(s_i)$.]
#bul[At that step, greedy had partial set $S'$. It rejected $o_i$, so $S' ∪ \{o_i\} ∉ cal(I)$.]
#bul[But $|S'| < |"OPT"_{(≤ i)}|$ and both are independent — by (I3), greedy should have been able to add some element from OPT. Contradiction. ∎]

*Proof sketch ($⇐$) — failing (I3) breaks greedy:*
#bul[Construct weights that force greedy to pick a smaller maximal set over a larger one — demonstrating sub-optimality.]

#pagebreak()

// ─── Slide: Exchange enables greedy ──────────────────────────────────────────
#footer-bar
#slide-header("Exchange Axiom: Why Greedy Cannot Get Stuck", part-label: "Part IV — Greedy Algorithms")

#info-box[
  The exchange axiom is precisely what prevents greedy from reaching a "local maximum trap".
]

*Without exchange:*
#bul[Two maximal independent sets can have different sizes.]
#bul[Greedy might fill up a small maximal set, missing a larger (better-weight) one.]
#bul[No way to "repair" the partial solution.]

*With exchange:*
#bul[All maximal independent sets have equal size (= rank of matroid).]
#bul[Greedy's partial solution is always extendable — it never gets permanently stuck.]
#bul[Any element missed by greedy could have been included (at the appropriate weight rank), contradicting greedy's sorted order.]

#thm-box("")[
  A family $cal(I)$ satisfying (I1) and (I2) is a matroid $⇔$ all maximal independent sets have equal cardinality (for every restriction to a subset $A ⊆ E$).
]

#pagebreak()

// ============================================================================
// PART V: Examples
// ============================================================================
#part-slide("V", "Greedy in Action", "Specialising to classical algorithms")

// ─── Slide: Partition matroid ─────────────────────────────────────────────────
#footer-bar
#slide-header("Partition Matroid: Best From Each Category", part-label: "Part V — Examples")

#defn-box("Partition Matroid")[
  $E$ partitioned into disjoint classes $E_1, E_2, …, E_m$ with quotas $k_1, …, k_m$. \
  $cal(I) = \{ S ⊆ E : |S ∩ E_i| ≤ k_i " for all " i \}$.
]

#ex-box("Job scheduling by type")[
  $E = \{"coding jobs"\} ∪ \{"design jobs"\} ∪ \{"testing jobs"\}$, quotas $k_1=2, k_2=1, k_3=2$. \
  Greedy: sort all jobs by value; pick each job if its category quota is not exceeded.
]

*Greedy specialisation:*
#bul[Sort all elements by weight descending.]
#bul[Add element $e ∈ E_i$ if $|S ∩ E_i| < k_i$.]
#bul[This is optimal by the matroid greedy theorem.]

*Application:* Bipartite matching $=$ common independent set of two partition matroids (matroid intersection).

#pagebreak()

// ─── Slide: Graphic matroid greedy ───────────────────────────────────────────
#footer-bar
#slide-header("Graphic Matroid: Maximum-Weight Forest", part-label: "Part V — Examples")

*Matroid:* $M(G) = (E, cal(I))$ where $E =$ edges, $cal(I) =$ acyclic subsets.

*Generic greedy on $M(G)$:*
#bul[Sort edges by weight descending (for max forest) or ascending (for MST).]
#bul[Add each edge if it does not create a cycle (independence check via Union-Find).]
#bul[Output: a maximum-weight spanning forest.]

#ex-box("Small worked example")[
  $G$: vertices $\{1,2,3,4\}$, edges with weights: $e_{12}=5, e_{23}=3, e_{34}=4, e_{14}=2, e_{13}=6$.
  Sorted desc: $e_{13}=6, e_{12}=5, e_{34}=4, e_{23}=3, e_{14}=2$. \
  Step 1: Add $e_{13}$. Step 2: Add $e_{12}$. Step 3: Add $e_{34}$. \
  Step 4: $e_{23}$ creates cycle $1{-}2{-}3{-}1$ — reject. Step 5: $e_{14}$ creates cycle — reject. \
  Max forest: $\{e_{13}, e_{12}, e_{34}\}$, weight $= 15$.
]

#info-box[For MST: negate weights (or sort ascending). Kruskal's algorithm is exactly this greedy!]

#pagebreak()

// ============================================================================
// PART VI: Minimum Spanning Trees
// ============================================================================
#part-slide("VI", "Minimum Spanning Trees", "Kruskal · Prim · Cut and Cycle Properties")

// ─── Slide: MST problem ──────────────────────────────────────────────────────
#footer-bar
#slide-header("The Minimum Spanning Tree Problem", part-label: "Part VI — MSTs")

#defn-box("Minimum Spanning Tree")[
  Given: connected undirected graph $G = (V, E)$, weight $w : E → bb(R)$. \
  Find: a spanning tree $T ⊆ E$ minimising $sum_(e ∈ T) w(e)$.
]

*Matroid connection:*
#bul[Graphic matroid $M(G) = (E, cal(I))$: $E =$ edges, $cal(I) =$ forests.]
#bul[Bases $=$ spanning trees. MST $=$ minimum-weight basis of $M(G)$.]
#bul[By the matroid greedy theorem: processing edges in ascending weight order and adding cycle-free edges is optimal.]

*Applications:*
#bul[Network design: cable routing, road construction, pipeline layout.]
#bul[Clustering: single-linkage hierarchical clustering.]
#bul[Approximation algorithms: MST gives a 2-approximation for TSP.]
#bul[Phylogenetics, image segmentation, circuit layout.]

#pagebreak()

// ─── Slide: Kruskal's Algorithm ──────────────────────────────────────────────
#footer-bar
#slide-header("Kruskal's Algorithm", part-label: "Part VI — MSTs")

#code-block[
  KRUSKAL(G = (V, E), w : E → ℝ):\
  Sort edges: e₁, e₂, ..., eₘ  with  w(e₁) ≤ w(e₂) ≤ ... ≤ w(eₘ)\
  T ← ∅          // growing MST forest\
  DSU.init(V)    // one component per vertex\
  for i = 1 to m do:\
  let eᵢ = (u, v)\
  if DSU.find(u) ≠ DSU.find(v)  then   // adding eᵢ creates no cycle\
  T ← T ∪ {eᵢ}\
  DSU.union(u, v)\
  return T
]

*Analysis:*
#bul[Independence check: $e_i = (u,v)$ is independent $⇔$ $u$ and $v$ are in different components of $(V,T)$. DSU.find: $O(α(|V|))$.]
#bul[Total time: $O(|E| log |E|)$ dominated by sorting.]
#bul[Correctness: direct corollary of the matroid greedy theorem applied to $M(G)$.]

#pagebreak()

// ─── Slide: Union-Find ───────────────────────────────────────────────────────
#footer-bar
#slide-header("Union-Find (Disjoint Set Union)", part-label: "Part VI — MSTs")

*Purpose:* Maintain a partition of $V$ into connected components of the growing forest.

#code-block[
  DSU.init(V):    each vertex forms its own singleton component\
  DSU.find(u):    return root/representative of the component containing u\
  DSU.union(u,v): merge the components of u and v\
  \
  Key invariant: find(u) == find(v)  ⟺  u and v are connected in current T
]

*Optimisations:*
#bul[*Union by rank:* always attach the shorter tree under the taller — keeps trees shallow.]
#bul[*Path compression:* during find, flatten all nodes directly to root — future finds faster.]
#bul[With both: amortised $O(α(n))$ per operation, where $α$ is the inverse Ackermann function.]
#bul[For all practical purposes: $α(n) ≤ 4$ for $n ≤ 10^{80}$.]

*In Kruskal's:* $|E|$ find operations + $|V|-1$ union operations $⇒$ total DSU cost $≈ O(|E|)$.

#pagebreak()

// ─── Slide: Kruskal worked example ───────────────────────────────────────────
#footer-bar
#slide-header("Kruskal's Algorithm: Worked Example", part-label: "Part VI — MSTs")

#two-col(
  [
    *Graph $G$:* 5 vertices $\{A,B,C,D,E\}$, 7 edges.

    #table(
      columns: (auto, auto, auto),
      stroke: med-gray,
      fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-gray },
      table.header(text(fill: white)[*Edge*], text(fill: white)[*Weight*], text(fill: white)[*Action*]),
      [C–E], [2], [Add ✓],
      [A–B], [4], [Add ✓],
      [D–E], [6], [Add ✓],
      [B–E], [7], [Add ✓],
      [A–D], [8], [Skip (cycle)],
      [B–C], [8], [Skip (cycle)],
      [B–D], [11], [Skip (cycle)],
    )
  ],
  [
    *MST found:* $T = \{C{-}E,\ A{-}B,\ D{-}E,\ B{-}E\}$

    Total weight $= 2 + 4 + 6 + 7 = bold(19)$

    #block(fill: gold-light, stroke: (paint: gold, thickness: 1pt), inset: 8pt, radius: 4pt)[
      After adding $C{-}E$: components $\{C,E\}, \{A\},\{B\},\{D\}$. \
      After $A{-}B$: $\{A,B\}$, $\{C,E\}$, $\{D\}$. \
      After $D{-}E$: $\{C,D,E\}$, $\{A,B\}$. \
      After $B{-}E$: $\{A,B,C,D,E\}$ — done!
    ]
  ],
)

#pagebreak()

// ─── Slide: Prim's Algorithm ─────────────────────────────────────────────────
#footer-bar
#slide-header("Prim's Algorithm", part-label: "Part VI — MSTs")

#code-block[
  PRIM(G = (V, E), w : E → ℝ, start s ∈ V):\
  key[v] ← ∞  for all v ∈ V;   key[s] ← 0\
  parent[v] ← NIL  for all v ∈ V\
  Q ← min-priority queue containing all vertices, keyed by key[·]\
  while Q ≠ ∅ do:\
  u ← EXTRACT-MIN(Q)\
  for each neighbour v of u do:\
  if v ∈ Q  and  w(u,v) < key[v]  then\
  parent[v] ← u\
  key[v] ← w(u,v)         ▷ DECREASE-KEY in Q\
  return { (parent[v], v) : v ≠ s }
]

*Analysis:*
#bul[Time: $O(|E| log |V|)$ with binary heap; $O(|E| + |V| log |V|)$ with Fibonacci heap.]
#bul[Prim grows a *single tree* from $s$, always adding the cheapest edge to a new vertex.]
#bul[Correctness: justified by the *cut property* — the minimum-weight crossing edge of any cut is in some MST.]

#pagebreak()

// ─── Slide: Cut and Cycle Properties ─────────────────────────────────────────
#footer-bar
#slide-header("Cut Property and Cycle Property", part-label: "Part VI — MSTs")

#thm-box("Cut Property")[
  For any cut $(S, V ∖ S)$ of $G$, the minimum-weight edge crossing the cut
  belongs to some MST. If this edge is unique, it belongs to every MST.
]

#thm-box("Cycle Property")[
  For any cycle $C$ in $G$, the maximum-weight edge of $C$ does not belong to any MST.
  If this edge is unique, it belongs to no MST.
]

*Connection to matroid structure:*
#bul[Cut property $↔$ exchange axiom: a sub-optimal tree can be augmented.]
#bul[Cycle property $↔$ circuit elimination: the heaviest circuit edge is excluded.]

*Algorithmic use:*
#bul[*Kruskal* uses the cycle property: skip edge if it creates a cycle.]
#bul[*Prim* uses the cut property: always take the cheapest edge out of the current tree.]

#pagebreak()

// ─── Slide: Kruskal vs Prim ──────────────────────────────────────────────────
#footer-bar
#slide-header("Kruskal vs Prim: Comparison", part-label: "Part VI — MSTs")

#table(
  columns: (auto, auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-blue },
  table.header(text(fill: white)[*Aspect*], text(fill: white)[*Kruskal's*], text(fill: white)[*Prim's*]),
  [Strategy], [Global edge sort], [Local vertex expansion],
  [Data structure], [Union-Find (DSU)], [Priority queue],
  [Grows], [A forest (multiple trees)], [One tree from start node],
  [Time], [$O(|E| log |E|)$], [$O(|E| log |V|)$ or better],
  [Best for], [Sparse graphs], [Dense graphs (Fibonacci heap)],
  [Matroid view], [Direct graphic matroid greedy], [Implicit; cut-property driven],
  [Correctness basis], [Matroid greedy theorem], [Cut property],
)

#v(0.3em)
#info-box[Both produce a minimum spanning tree. Kruskal aligns _directly_ with the graphic matroid greedy algorithm; Prim's matroid interpretation is more implicit.]

#pagebreak()

// ============================================================================
// PART VII: Beyond MSTs
// ============================================================================
#part-slide("VII", "Beyond MSTs", "Matroid intersection · Submodularity · Generalisations")

// ─── Slide: Matroid intersection ─────────────────────────────────────────────
#footer-bar
#slide-header("Matroid Intersection", part-label: "Part VII — Beyond MSTs")

#defn-box("Matroid Intersection")[
  Given two matroids $M_1 = (E, cal(I)_1)$ and $M_2 = (E, cal(I)_2)$ on the same ground set, \
  find a maximum-weight set $S ∈ cal(I)_1 ∩ cal(I)_2$.
]

#ex-box("Bipartite Matching")[
  $G = (U ∪ V, E)$. A matching $=$ edge set where each vertex appears $≤ 1$ time. \
  $M_1$: partition matroid on $U$ — at most one edge per $u ∈ U$. \
  $M_2$: partition matroid on $V$ — at most one edge per $v ∈ V$. \
  Maximum matching $=$ max common independent set of $M_1$ and $M_2$.
]

*Complexity:*
#bul[Single matroid: greedy, $O(|E| log |E|)$.]
#bul[Matroid intersection: solvable in polytime via augmenting paths, $O(|E|^{1.5} ⋅ T_{"oracle"})$.]
#bul[Three-matroid intersection: NP-hard in general!]

#pagebreak()

// ─── Slide: Submodular opt ────────────────────────────────────────────────────
#footer-bar
#slide-header("Submodular Optimisation over Matroids", part-label: "Part VII — Beyond MSTs")

#defn-box("Submodular Function")[
  $f : 2^E → bb(R)$ is *submodular* if for all $A, B ⊆ E$: \
  $f(A ∪ B) + f(A ∩ B) ≤ f(A) + f(B)$ \
  (equivalently: $f$ has _diminishing marginal returns_).
]

*Connection to matroids:*
#bul[The rank function $r$ of any matroid is submodular.]
#bul[Maximising a monotone submodular function subject to a matroid constraint: greedy achieves a $(1 - 1/e) ≈ 0.632$ approximation!]

*Applications:*
#bul[*Influence maximisation* in social networks (viral marketing).]
#bul[*Feature selection* in machine learning.]
#bul[*Sensor placement* for maximum coverage.]
#bul[*Welfare maximisation* in combinatorial auctions.]

#pagebreak()

// ─── Slide: Greedoids ────────────────────────────────────────────────────────
#footer-bar
#slide-header("Generalisations: Greedoids and Antimatroids", part-label: "Part VII — Beyond MSTs")

*What if we relax matroid axioms?*

#defn-box("Greedoid")[
  $(E, cal(F))$ with $∅ ∈ cal(F)$ and: for $A, B ∈ cal(F)$ with $|A| > |B|$,
  $∃ e ∈ A$ s.t. $B ∪ \{e\} ∈ cal(F)$. \
  Heredity (I2) is *not required*.
]

*Examples of greedoids:*
#bul[Branching greedoids (rooted spanning trees explored in BFS order).]
#bul[Ear decompositions of graphs.]
#bul[Gaussian elimination sequences.]

#defn-box("Antimatroid")[
  Satisfies heredity (I2) but not exchange. Models "reachable" sets: start from a feasible set and expand. \
  Examples: convex point sets, node-search in trees.
]

#info-box[Greedoids and antimatroids extend matroid theory to capture even more greedy-like algorithms beyond the classical matroid framework.]

#pagebreak()

// ─── Slide: Applications ─────────────────────────────────────────────────────
#footer-bar
#slide-header("Applications of Matroid Theory", part-label: "Part VII — Beyond MSTs")

#table(
  columns: (auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-blue },
  table.header(text(fill: white)[*Application Domain*], text(fill: white)[*Matroid concept used*]),
  [Network design (cable, roads)], [Graphic matroid — MST],
  [Bipartite matching], [Matroid intersection],
  [Job scheduling], [Partition / transversal matroids],
  [Error-correcting codes], [Linear matroids over finite fields],
  [VLSI circuit layout], [Linear matroids, connectivity],
  [Influence / viral marketing], [Submodular optimisation over matroids],
  [Approximation algorithms (TSP)], [MST as 2-approximation],
  [Phylogenetics], [MST for tree reconstruction],
  [Image segmentation], [Graph-cut / matroid methods],
  [Combinatorial auctions], [Submodular welfare maximisation],
)

#pagebreak()

// ============================================================================
// PART VIII: Summary
// ============================================================================
#part-slide("VIII", "Summary & Takeaways", "The big picture")

// ─── Slide: Summary ──────────────────────────────────────────────────────────
#footer-bar
#slide-header("Key Takeaways", part-label: "Part VIII — Conclusion")

#block(width: 100%, fill: light-blue, stroke: (paint: mid-blue, thickness: 1.5pt), inset: 12pt, radius: 6pt)[

  #bul[A *matroid* $M = (E, cal(I))$ abstracts the notion of independence from linear algebra, graph theory, and combinatorics.]

  #bul[The three axioms — non-emptiness, heredity, and *exchange* — precisely characterise when greedy is globally optimal.]

  #bul[All bases of a matroid have equal size, giving a consistent notion of *rank*.]

  #bul[*Matroid Greedy Theorem (Edmonds 1971):* Greedy finds a maximum-weight basis for every weight function iff the feasible sets form a matroid.]

  #bul[*Graphic matroids* explain why Kruskal's and Prim's MST algorithms are correct.]

  #bul[Matroids set the *exact boundary* between greedy algorithms that are provably correct and those that are merely plausible-looking.]
]

#pagebreak()

// ─── Slide: References ───────────────────────────────────────────────────────
#footer-bar
#slide-header("References", part-label: "Further Reading")

#table(
  columns: (auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-gray },
  table.header(text(fill: white)[*Reference*], text(fill: white)[*Focus*]),
  [Oxley, J. (2011). _Matroid Theory_, 2nd ed. Oxford University Press.], [Comprehensive reference on matroid theory],

  [Edmonds, J. (1971). "Matroids and the Greedy Algorithm." _Math. Programming_ 1, 127–136.],
  [Original paper — matroid greedy theorem],

  [Cormen, Leiserson, Rivest, Stein. _Introduction to Algorithms_, 4th ed. MIT Press.],
  [MST algorithms, greedy, Union-Find],

  [Schrijver, A. (2003). _Combinatorial Optimization_. Springer.], [Matroids, polymatroids, submodularity],

  [Korte, B. & Vygen, J. (2012). _Combinatorial Optimization_, 5th ed. Springer.], [Greedoids, matroids, algorithms],

  [Welsh, D. (1976). _Matroid Theory_. Academic Press.], [Classic textbook — readable and complete],

  [Lawler, E. (1975). "Matroid Intersection Algorithms." _Math. Programming_ 9, 31–56.],
  [Matroid intersection algorithms],
)

#pagebreak()

// ─── Appendix ────────────────────────────────────────────────────────────────
#footer-bar
#slide-header("Appendix: Equivalent Axiom Systems", part-label: "Appendix")

A matroid can be equivalently defined via any of the following systems:

#table(
  columns: (auto, auto),
  stroke: med-gray,
  fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-blue },
  table.header(text(fill: white)[*System*], text(fill: white)[*Key axiom*]),
  [Independent sets $cal(I)$], [(I3) Exchange: smaller $cal(I)$-set can be augmented from larger],

  [Bases $cal(B)$],
  [(B2) Basis exchange: $∀ B_1,B_2 ∈ cal(B),\ ∀ e ∈ B_1 ∖ B_2,\ ∃ f ∈ B_2 ∖ B_1 : (B_1 ∖ \{e\}) ∪ \{f\} ∈ cal(B)$],

  [Circuits $cal(C)$], [(C3) Elimination: $C_1 ≠ C_2,\ e ∈ C_1 ∩ C_2 ⇒ ∃ C_3 ⊆ (C_1 ∪ C_2) ∖ \{e\}$],

  [Rank $r$], [(R3) Submodularity: $r(A ∪ B) + r(A ∩ B) ≤ r(A) + r(B)$],

  [Closure $"cl"$], [(CL4) Mac Lane: $e ∉ "cl"(A),\ e ∈ "cl"(A ∪ \{f\}) ⇒ f ∈ "cl"(A ∪ \{e\})$],
)

#v(0.5em)
#bul[Each system has strengths: circuits for graphic matroids, rank for linear algebra, bases for optimisation.]
#bul[Proving all systems equivalent is a rewarding exercise — each equivalence is constructive.]
