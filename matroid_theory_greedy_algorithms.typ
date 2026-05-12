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

#bul[The feasible sets $\{S : "weight"(S) lt.eq 10\}$ do *not* form a matroid.]
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
    text(fill: white)[*Setting*], text(fill: white)[*Ground Set $E$*], text(fill: white)[*Independent Sets $cal(I)$*]
  ),
  [Choose $lt.eq k$ items], [Items], [Subsets of size $lt.eq k$],
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

#defn-box([Matroid  $M = (E, cal(I))$])[
  A *matroid* is a pair $M = (E, cal(I))$ where $E$ is a finite set and
  $cal(I) subset.eq 2^E$ satisfies: \

  *(I1) Non-emptiness:* $emptyset in cal(I)$ \
  *(I2) Heredity:* If $A in cal(I)$ and $B subset.eq A$, then $B in cal(I)$ \
  *(I3) Exchange:* If $A, B in cal(I)$ and $|A| < |B|$,
  then $exists x in B without A$ such that $A union \{x\} in cal(I)$
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
  #align(center)[#text(
    size: 15pt,
    weight: "bold",
    fill: mid-blue,
  )[(I1)  The empty set is independent: $emptyset in cal(I)$]]
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
    (I2)  If $A in cal(I)$ and $B subset.eq A$, then $B in cal(I)$
  ]]
]

*Interpretation:*

Subsets of independent sets are independent. Independence is _downward-closed_.

*In each setting:*

#bul[*Vectors:* Any subset of linearly independent vectors is linearly independent.]
#bul[*Edges:* Any subset of an acyclic edge set is also acyclic.]
#bul[*Selection:* If choosing $k$ items is feasible, choosing fewer is also feasible.]

#warn-box("Does the Knapsack feasible system violate heredity?")[
  Feasible sets are $\{S : "weight"(S) lt.eq 10\}$. $\{B, C\}$ is feasible
  as well as $\{A\}$.
  The issue: adding $B$ or $C$ to $\{A\}$ _exceeds_ capacity, so $\{A,B\} in.not cal(I)$.
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
    (I3)  If $A, B in cal(I)$ and $|A| lt |B|$,
    then $∃ x in B without A$ such that $A union \{x\} in cal(I)$
  ]]
]

*Interpretation:*

Any smaller independent set can be _augmented_ from a larger one.

#bul[We can always "fill up" a small independent set using elements of a bigger one.]
#bul[This is the *heart of greedy correctness* — we prove this formally in Part IV.]
#bul[In linear algebra: if $dim(A) lt dim(B)$, we can find a vector in $B$ not in $"span"(A)$.]

*Why this matters algorithmically:*

#bul[Exchange prevents greedy from reaching a "dead end" — a locally maximal but globally sub-optimal solution.]
#bul[It implies all maximal independent sets have equal size — no "accidentally small" solutions.]


#pagebreak()

// ─── Slide: Basic terminology: Bases and Rank ────────────────────────────────
#footer-bar
#slide-header("Basic Terminology: Bases and Rank", part-label: "Part II — First Principles")

#defn-box("Basis")[
  A *basis* of a matroid $M = (E, cal(I))$ is a maximal independent set:
  $B in cal(I)$ and no element $e in E without B$ can be added while staying independent.
]

#defn-box([Rank])[
  For $A subset.eq E$, the *rank* of $A$ is the size of the largest independent subset of $A$: \
  $r(A) = max_(I subset.eq A, I in cal(I)) |I|$. \
  The *rank of the matroid* is $r(E)$.
]

These terms are introduced here because they are used in the examples below.
Part III develops them further, including circuits and closure.

#pagebreak()

// ─── Slide: Uniform Matroid ───────────────────────────────────────────────────
#footer-bar
#slide-header([Uniform Matroids $U#sub[k,n]$], part-label: "Part II — First Principles")

#defn-box([Uniform Matroid $U#sub[k,n]$])[
  Ground set: $E = \{1, 2, dots, n\}$. \
  Independent sets: $cal(I) = \{ A subset.eq E : |A| lt.eq k \}$.
]

#ex-box([$U#sub[2,4], E = \{a, b, c, d\}$, $k = 2$])[
  $cal(I)$ = $\{emptyset, \{a\}, \{b\}, \{c\}, \{d\}, \{a,b\}, \{a,c\}, \{a,d\}, \{b,c\}, \{b,d\}, \{c,d\}\}$ \
  Dependent sets: $\{a,b,c\}, \{a,b,d\}, \{a,c,d\}, \{b,c,d\}, \{a,b,c,d\}$
]

*Axiom verification:*

#bul[(I1) $emptyset in cal(I)$ since $|emptyset| = 0 lt.eq k$.]
#bul[(I2) If $|A| lt.eq k$ and $B subset.eq A$, then $|B| lt.eq |A| lt.eq k$.]
#bul[(I3) If $|A| lt |B| lt.eq k$, pick any $x in B without A$.  Then $|A union \{x\}| = |A|+1 lt.eq |B| lt.eq k$.]

#bul[*Greedy on $U#sub[k,n]$:* simply select the $k$ highest-weight elements. Trivially optimal.]

#pagebreak()

// ─── Slide: Linear Matroid ────────────────────────────────────────────────────
#footer-bar
#slide-header("Linear Matroids", part-label: "Part II — First Principles")

#defn-box("Linear Matroid")[
  Let $bb(F)$ be a field, $A$ an $m times n$ matrix over $bb(F)$. \
  Ground set: $E = \{1, dots, n\}$ (column indices). \
  Independent sets: $cal(I) = \{ S subset.eq E : "columns indexed by " S " are linearly independent" \}$.
]

#ex-box([Over $bb(R)$])[
  $A = mat(1, 0, 1; 0, 1, 1)$.
  Columns: $v_1 = mat(1; 0)$, $v_2 = mat(0; 1)$, $v_3 = mat(1; 1)$. \
  Independent: $\{1\}, \{2\}, \{3\}, \{1,2\}, \{1,3\}, \{2,3\}$. \
  Dependent: $\{1,2,3\}$ since $v_3 = v_1 + v_2$.
]

#bul[Exchange axiom $arrow.l.r$ the linear-algebra augmentation lemma for bases.]
#bul[Rank of matroid $=$ column rank of $A$.]

#pagebreak()

// ─── Slide: Graphic Matroid ───────────────────────────────────────────────────
#footer-bar
#slide-header([Graphic Matroids $M(G)$], part-label: "Part II — First Principles")

#defn-box([Graphic Matroid $M(G)$])[
  Let $G = (V, E)$ be an undirected graph. \
  Ground set: $E$ (edges of $G$). \
  Independent sets: $cal(I) = \{ F subset.eq E : (V, F) " is a forest (acyclic)" \}$.
]

*Structure:*

#bul[Bases $=$ spanning forests; in connected $G$: bases $=$ spanning trees (each with $|V|-1$ edges).]
#bul[Rank: $r(F) = |V| - ("number of components of " (V,F))$.]

*Axiom verification:*

#bul[(I1) Empty edge set is an acyclic forest.]
#bul[(I2) Any subset of an acyclic edge set is acyclic.]
#bul[(I3) Two forests $F_1, F_2$ with $|F_1| lt |F_2|$: $F_2$ has fewer components, so some edge of $F_2$ connects two components of $F_1$ — adding it stays acyclic. ]

#pagebreak()

// ─── Slide: Non-example ──────────────────────────────────────────────────────
#footer-bar
#slide-header("A Non-Example: Failure of the Exchange Axiom", part-label: "Part II — First Principles")

#warn-box("Non-matroid: mismatched maximal sets")[
  $E eq \{a, b, c\}$, $cal(I) eq \{emptyset, \{a\}, \{b,c\}\}$. \
  Both $\{a\}$ and $\{b,c\}$ are maximal (cannot add any element). \
  But $|\{a\}| eq 1 eq.not 2 eq |\{b,c\}|$. \
  Exchange fails: from $\{b,c\}$, we cannot augment $\{a\}$ — $\{a,b\} ∉ cal(I)$ and $\{a,c\} ∉ cal(I)$.
]

#warn-box("Diagnostic")[
  If (I3) fails, there exist weights making greedy suboptimal. \
  *Proof:* Assign $w(a) = 5$, $w(b) = w(c) = 3$. \
  Greedy picks $\{a\}$ (value 5). But $\{b,c\}$ has value 6. Greedy fails.
]

#info-box[
  *Key lesson:* Always verify the matroid axioms before trusting a generic greedy algorithm.
  For a hereditary independence system, (I3) is the decisive axiom: greedy is optimal for every weight function if and only if exchange holds. If exchange fails, some weight function makes greedy fail.
]

#pagebreak()

// ============================================================================
// PART III: Bases, Rank, Circuits, Closure
// ============================================================================
#part-slide("III", "Structure", "Bases · Rank · Circuits · Closure")

// ─── Slide: Bases ─────────────────────────────────────────────────────────────
#footer-bar
#slide-header("Bases Revisited", part-label: "Part III — Structure")

#defn-box("Basis (full statement)")[
  A *basis* of $M = (E,cal(I))$ is a maximal independent set: $B in cal(I)$ such that
  $B union \{e\} in.not cal(I)$ for all $e in E without B$. \
  The collection of all bases is denoted $cal(B)(M)$.
]

#thm-box("Equal Cardinality of Bases")[
  All bases of a matroid have the same cardinality. \
  *Proof sketch:* Suppose $|B_1| lt |B_2|$. By (I3), $exists e in B_2 without B_1$
  with $B_1 union \{e\} in cal(I)$, contradicting maximality of $B_1$. $square.filled$
]

*Examples:*

#bul[$U_(k,n)$: all bases have size exactly $k$.]
#bul[Linear matroid on $A$: bases are maximal linearly independent column sets — all have size $= "rank"(A)$.]
#bul[Graphic matroid on connected $G$: bases $=$ spanning trees, all of size $|V|-1$.]

#pagebreak()

// ─── Slide: Rank ─────────────────────────────────────────────────────────────
#footer-bar
#slide-header("Rank Function Revisited", part-label: "Part III — Structure")

#defn-box([Rank  $r : 2^E → bb(Z)_(gt.eq 0)$ (full statement)])[
  For $A subset.eq E$: $r(A) = max\{|I| : I in cal(I), I subset.eq A\}$.

  The *rank of the matroid* is $r(E)$.
]

*Key properties:*

#bul[(R1) $0 lt.eq r(A) lt.eq |A|$]
#bul[(R2) *Monotone*: $A subset.eq B arrow.double r(A) lt.eq r(B)$]
#bul[(R3) *Submodular*: $r(A union B) + r(A inter B) lt.eq r(A) + r(B)$]

#info-box[
  Let $C = A inter B$. Since $C subset.eq A$ and $B subset.eq A union B$,
  monotonicity gives
  $
    r(C) lt.eq r(A), quad r(B) lt.eq r(A union B).
  $

  The rank gained by adding $A$ to the larger set $B$
  is no more than the rank gained by adding $A$ to $C$:
  $
    r(A union B) - r(B) lt.eq r(A) - r(C).
  $

  Using $C = A inter B$ and rearranging,
  $
    r(A union B) + r(A inter B) lt.eq r(A) + r(B).
  $
]

*In specific matroids:*

#bul[$U_(k,n)$: $r(A) = min(|A|, k)$.]
#bul[Linear matroid: $r(A) =$ column rank of the submatrix with columns in $A$.]
#bul[Graphic matroid: $r(F) = |V| - c(F)$ where $c(F)$ = number of connected components.]

#pagebreak()

// ─── Slide: Circuits ─────────────────────────────────────────────────────────
#footer-bar
#slide-header("Circuits", part-label: "Part III — Structure")

#defn-box("Circuit")[
  A *circuit* is a minimal dependent set: $C subset.eq E$ with $C in.not cal(I)$
  but $C without \{e\} in cal(I)$ for every $e in C$. \
  The collection of all circuits is $cal(C)(M)$.
]

#two-col(
  [
    *In graphic matroids:*

    #bul[Circuits $=$ simple cycles of $G$.]
    #bul[Adding any edge to a spanning tree creates exactly one circuit.]
    #bul[Cycle property: the heaviest edge in any cycle belongs to no MST.]
  ],
  [
    *Circuit properties:*

    #bul[No circuit is a subset of another.]
    #bul[*Circuit elimination:* If $C_1, C_2 in cal(C)(M)$ and $e in C_1 inter C_2$, then $exists C_3 in cal(C)(M)$ with $C_3 subset.eq (C_1 ∪ C_2) without \{e\}$.]
  ],
)

#info-box[
  Let $X=(C_1 union C_2) without \{e\}$.
  Suppose no circuit lies in $X$. Then $X$ is independent, so $r(X)=|X|.$

  Since $C_1,C_2$ are circuits, $r(C_i)=|C_i|-1$.
  By submodularity, $r(C_1 union C_2)+r(C_1 inter C_2) lt.eq |C_1|+|C_2|-2.$

  But $X$ independent gives $r(C_1 union C_2)=r(X)=|C_1 union C_2|-1,$

  and always
  $
    r(C_1 inter C_2) lt.eq |C_1 inter C_2|.
  $

  Hence
  $
    |C_1 union C_2|-1 + |C_1 inter C_2|
    lt.eq |C_1|+|C_2|-2.
  $

  So
  $
    |C_1 union C_2| + |C_1 inter C_2|
    lt.eq |C_1|+|C_2|-1,
  $
  contradicting
  $
    |C_1 union C_2| + |C_1 inter C_2| = |C_1|+|C_2|.
  $

  Therefore $X$ is dependent and contains a circuit $C_3 subset.eq X$.
]

#pagebreak()

// ─── Slide: Closure ──────────────────────────────────────────────────────────
#footer-bar
#slide-header("Closure (Span)", part-label: "Part III — Structure")

#defn-box([Closure  $"cl" : 2^E arrow 2^E$])[
  $"cl"(A) = \{ e in E : r(A union \{e\}) = r(A) \}$. \
  Equivalently: $e in "cl"(A)$ iff adding $e$ to $A$ does not increase rank.
]

*Intuition:*

#bul[$"cl"(A)$ is the "span" of $A$ — all elements already "dependent" on $A$.]
#bul[Linear matroids: $"cl"(A) = \{$vectors in $E$ lying in $"span"(A)\}$.]
#bul[Graphic matroids: $"cl"(F) = F ∪ \{$edges whose endpoints are connected in $(V,F)\}$.]

*Closure axioms (alternative axiom system for matroids):*

#bul[(CL1) $A ⊆ "cl"(A)$]
#bul[(CL2) $A ⊆ B ⇒ "cl"(A) ⊆ "cl"(B)$]
#bul[(CL3) $"cl"("cl"(A)) = "cl"(A)$]
#bul[(CL4) *Mac Lane–Steinitz:* $e in.not "cl"(A)$ and $e in "cl"(A union \{f\}) arrow.double f in "cl"(A union \{e\})$]

#pagebreak()

// ============================================================================
// PART IV: Greedy Algorithms and Matroids
// ============================================================================
#part-slide("IV", "Greedy Algorithms & Matroids", "The central theorem and its proof")

// ─── Slide: Generic greedy ───────────────────────────────────────────────────
#footer-bar
#slide-header("The Generic Greedy Algorithm for Matroids", part-label: "Part IV — Greedy Algorithms")

#code-block[
  GREEDY($M = (E, cal(I)), w : E arrow bb(R)$):\
  Sort elements: $e_1, e_2, dots, e_n$  with  $w(e_1) gt.eq w(e_2) gt.eq dots gt.eq w(e_n)$\
  $S arrow.l emptyset$\
  for $i arrow.l 1 dots n$ do: if $S union {e_i} in cal(I)$: $S arrow.l S union {e_i}$\
  return $S$
]

*Properties:*

#bul[Time: $O(n log n)$ for sorting + $n$ independence oracle calls.]
#bul[Correctness: holds *if and only if* $M = (E, cal(I))$ is a matroid.]
#bul[Independence oracle examples:]
#bul2[$U_(k,n)$: check $|S| lt.eq k$. $O(1)$.]
#bul2[Graphic: check cycle via Union-Find. $O(alpha(n))$ amortised.]
#bul2[Linear: check rank via Gaussian elimination. $O(n^2)$.]

#pagebreak()

// ─── Slide: Matroid greedy theorem ───────────────────────────────────────────
#footer-bar
#slide-header("The Matroid Greedy Theorem", part-label: "Part IV — Greedy Algorithms")

#thm-box("Matroid Greedy Theorem (Edmonds, 1971)")[
  Let $(E, cal(I))$ be an independence system (satisfying I1 and I2).
  The greedy algorithm finds a maximum-weight basis for *every* weight function
  $w : E arrow bb(R)_(gt.eq 0)$ *if and only if* $(E, cal(I))$ is a matroid.
]

*Proof sketch ($arrow.double$) — matroids make greedy optimal:*

#info-box[
  #bul[Let greedy choose $S={s_1,dots,s_k}$ in decreasing weight order.]
  #bul[We build an optimal basis $O_i$ containing the greedy prefix
    ${s_1,dots,s_i}$.]
  #bul[Start with any optimal basis $O_0$. Suppose $O_(i-1)$ contains
    $G_(i-1)={s_1,dots,s_(i-1)}$.]
  #bul[If $s_i in.not O_(i-1)$, then $O_(i-1) union \{s_i\}$ contains a
    circuit $C$ with $s_i in C$. Since $G_(i-1) union \{s_i\}$ is independent,
    $C$ contains some $o in O_(i-1) without G_(i-1)$. Removing this $o$ breaks
    the circuit, so
    $
      O_i = O_(i-1) without \{o\} union \{s_i\}
    $
    is again a basis.]
  #bul[Since $G_(i-1) union \{o\} subset.eq O_(i-1)$, the element $o$ was feasible
    when greedy chose $s_i$. Hence
    $
      w(s_i) gt.eq w(o).
    $]
  #bul[So replacing $o$ by $s_i$ does not decrease total weight. Thus $O_i$ is
    still optimal and contains the longer greedy prefix.]
  #bul[After all steps, an optimal basis contains all of $S$; since both are bases,
    it equals $S$. Therefore greedy is optimal. $square.filled$]
]

*Proof sketch ($arrow.l.double$) — failing (I3) breaks greedy:*

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
  A family $cal(I)$ satisfying (I1) and (I2) is a matroid $arrow.l.r.double$ all maximal independent sets have equal cardinality (for every restriction to a subset $A subset.eq E$).
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
  $E$ partitioned into disjoint classes $E_1, E_2, dots, E_m$ with quotas $k_1, dots, k_m$. \
  $cal(I) = \{ S subset.eq E : |S inter E_i| lt.eq k_i " for all " i \}$.
]

#ex-box("Job scheduling by type")[
  $E = \{"coding jobs"\} union \{"design jobs"\} union \{"testing jobs"\}$, quotas $k_1=2, k_2=1, k_3=2$. \
  Greedy: sort all jobs by value; pick each job if its category quota is not exceeded.
]

*Greedy specialisation:*

#bul[Sort all elements by weight descending.]
#bul[Add element $e in E_i$ if $|S inter E_i| lt k_i$.]
#bul[This is optimal by the matroid greedy theorem.]

*Application:* Bipartite matching $=$ common independent set of two partition matroids (matroid intersection).

#info-box[
  Let $G=(L union R, E)$ be bipartite, and take the ground set to be the edges.

  Define two partition matroids on $E$:

  #bul[$M_L$: at most one chosen edge incident to each $u in L$.]
  #bul[$M_R$: at most one chosen edge incident to each $v in R$.]

  A set $F subset.eq E$ is independent in both iff no two edges in $F$ share
  a left endpoint or a right endpoint. That is exactly a matching.

  Hence bipartite matching is a *matroid intersection* problem:
  $
    F in cal(I)_L inter cal(I)_R.
  $
]

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
  $G$: vertices $\{1,2,3,4\}$, edges with weights: $e_(12)=5, e_(23)=3, e_(34)=4, e_(14)=2, e_(13)=6$.
  Sorted desc: $e_(13)=6, e_(12)=5, e_(34)=4, e_(23)=3, e_(14)=2$. \
  Step 1: Add $e_(13)$. Step 2: Add $e_(12)$. Step 3: Add $e_(34)$. \
  Step 4: $e_(23)$ creates cycle $1-2-3-1$ — reject. Step 5: $e_(14)$ creates cycle — reject. \
  Max forest: $\{e_(13), e_(12), e_(34)\}$, weight $= 15$.
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
  Given: connected undirected graph $G = (V, E)$, weight $w : E arrow bb(R)$. \
  Find: a spanning tree $T subset.eq E$ minimising $sum_(e in T) w_(e)$.
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
  KRUSKAL($G = (V, E), w : E arrow bb(R)$):\
  Sort edges: $e_1, e_2, dots, e_m$  with  $w(e_1) lt.eq w(e_2) lt.eq dots lt.eq w(e_m)$\
  $T arrow.l emptyset$\         // growing MST forest
  DSU.init($V$)\    // one component per vertex
  for $i arrow.l 1 dots m$:\
  #h(2em) let $e_i = (u, v)$\
  #h(2em) if DSU.find($u$) $eq.not$ DSU.find($v$):\   // adding eᵢ creates no cycle
  #h(2em)#h(2em) $T arrow.l T union {e_i}$\
  #h(2em)#h(2em) DSU.union($u, v$)\
  return $T$
]

*Analysis:*

#bul[Independence check: adding $e_i = (u,v)$ is independent $arrow.l.r.double$ $u$ and $v$ are in different components of $(V,T)$. DSU.find: $O(alpha(|V|))$.]
#bul[Total time: $O(|E| log |E|)$ dominated by sorting.]
#bul[Correctness: direct corollary of the matroid greedy theorem applied to $M(G)$.]

#pagebreak()

// ─── Slide: Union-Find ───────────────────────────────────────────────────────
#footer-bar
#slide-header("Union-Find (Disjoint Set Union)", part-label: "Part VI — MSTs")

*Purpose:* Maintain a partition of $V$ into connected components of the growing forest.

#code-block[
  DSU.init($V$):    each vertex forms its own singleton component\
  DSU.find($u$):    return root/representative of the component containing $u$\
  DSU.union($u,v$): merge the components of $u$ and $v$\
  \
  Key invariant: find($u$) = find($v$)  $arrow.l.r.double$  $u$ and $v$ are connected in current $T$
]

*Optimisations:*

#bul[*Union by rank:* always attach the shorter tree under the taller — keeps trees shallow.]
#bul[*Path compression:* during find, flatten all nodes directly to root — future finds faster.]
#bul[With both: amortised $O(alpha(n))$ per operation, where $alpha$ is the inverse Ackermann function.]
#bul[For all practical purposes: $alpha(n) lt.eq 4$ for $n lt.eq 10^(80)$.]

*In Kruskal's:* $|E|$ find operations + $|V|-1$ union operations $arrow.double$ total DSU cost $approx O(|E|)$.

#pagebreak()

// ─── Slide: Kruskal worked example ───────────────────────────────────────────
#footer-bar
#slide-header("Kruskal's Algorithm: Worked Example", part-label: "Part VI — MSTs")

#two-col(
  [
    *Graph $G$:* 5 vertices ${A,B,C,D,E}$, 7 edges.

    #table(
      columns: (auto, auto, auto),
      stroke: med-gray,
      fill: (col, row) => if row == 0 { dark-blue } else if calc.even(row) { white } else { light-gray },
      table.header(text(fill: white)[*Edge*], text(fill: white)[*Weight*], text(fill: white)[*Action*]),
      [$C–E$], [2], [Add $checkmark$],
      [$A–B$], [4], [Add $checkmark$],
      [$D–E$], [6], [Add $checkmark$],
      [$B–E$], [7], [Add $checkmark$],
      [$A–D$], [8], [Skip (cycle)],
      [$B–C$], [8], [Skip (cycle)],
      [$B–D$], [11], [Skip (cycle)],
    )
  ],
  [
    *MST found:* $T = {C-E, A-B, D-E, B-E}$

    Total weight $= 2 + 4 + 6 + 7 = bold(19)$

    #block(fill: gold-light, stroke: (paint: gold, thickness: 1pt), inset: 8pt, radius: 4pt)[
      After adding $C-E$: components ${C,E}, {A},{B},{D}$. \
      After $A-B$: ${A,B}$, ${C,E}$, ${D}$. \
      After $D-E$: ${C,D,E}$, ${A,B}$. \
      After $B-E$: ${A,B,C,D,E}$ — done!
    ]
  ],
)

#pagebreak()

// ─── Slide: Prim's Algorithm ─────────────────────────────────────────────────
#footer-bar
#slide-header("Prim's Algorithm", part-label: "Part VI — MSTs")

#code-block[
  PRIM($G = (V, E), w : E arrow bb(R), s in V$):\
  key[$v$] $arrow.l infinity$  for all $v in V$\
  parent[$v$] $arrow.l$ NIL  for all $v in V$\
  key[$s$] $arrow.l 0$\
  $Q arrow.l$ min-priority queue containing all vertices, keyed by key[·]\
  while $Q eq.not emptyset$:\
  #h(2em) $u arrow.l$ EXTRACT-MIN($Q$)\
  #h(2em) for each neighbour $v$ of $u$:\
  #h(2em)#h(2em) if $v in Q$  and  $w(u,v) lt$ key[$v$]:\
  #h(2em)#h(2em)#h(2em) parent[$v$] $arrow.l u$\
  #h(2em)#h(2em)#h(2em) key[$v$] $arrow.l w(u,v)$\
  #h(2em)#h(2em)#h(2em) DECREASE-KEY($Q$, $v$, key[$v$])\
  return { (parent[$v$], $v$) : $v in V without {s}$ }
]

*Analysis:*

#bul[Assumes $G$ is connected; otherwise this returns a spanning tree only for the component reachable from $s$.]
#bul[Time: $O(|E| log |V|)$ with a binary heap; $O(|E| + |V| log |V|)$ with a Fibonacci heap.]
#bul[Prim grows a *single tree* from $s$, repeatedly adding the cheapest edge from the current tree to a new vertex.]
#bul[Correctness: by the *cut property* — at each step, the cheapest edge crossing from the current tree to the remaining vertices is safe.]

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

#bul[Cut property $arrow.l.r.double$ exchange axiom: a sub-optimal tree can be augmented.]
#bul[Cycle property $arrow.l.r.double$ circuit elimination: the heaviest circuit edge is excluded.]

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
#info-box[
  Both produce a minimum spanning tree. Kruskal aligns _directly_ with the graphic matroid greedy algorithm; Prim's matroid interpretation is more implicit.
]

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
  find a maximum-weight set $S in cal(I)_1 inter cal(I)_2$.
]

#ex-box("Bipartite Matching")[
  $G = (U union V, E)$. A matching $=$ edge set where each vertex appears $≤ 1$ time. \
  $M_1$: partition matroid on $U$ — at most one edge per $u in U$. \
  $M_2$: partition matroid on $V$ — at most one edge per $v in V$. \
  Maximum matching $=$ max common independent set of $M_1$ and $M_2$.
]

*Complexity:*

#bul[Single matroid: greedy, $O(|E| log |E|)$.]
#bul[Matroid intersection: solvable in polytime via augmenting paths, $O(|E|^(1.5) ⋅ T_("oracle"))$.]
#bul[Three-matroid intersection: NP-hard in general!]

#pagebreak()

// ─── Slide: Submodular opt ────────────────────────────────────────────────────
#footer-bar
#slide-header("Submodular Optimisation over Matroids", part-label: "Part VII — Beyond MSTs")

#defn-box("Submodular Function")[
  $f : 2^E → bb(R)$ is *submodular* if for all $A, B ⊆ E$: \
  $f(A union B) + f(A inter B) lt.eq f(A) + f(B)$ \
  (equivalently: $f$ has _diminishing marginal returns_).
]

*Connection to matroids:*

#bul[The rank function $r$ of any matroid is submodular.]
#bul[Maximising a monotone submodular function subject to a matroid constraint: greedy achieves a $(1 - 1/e) approx 0.632$ approximation!]

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
  $(E, cal(F))$ with $emptyset in cal(F)$ and: for $A, B in cal(F)$ with $|A| gt |B|$,
  $exists e in A$ s.t. $B union {e} in cal(F)$. \
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

#align(center)[
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
]

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

A matroid can be specified through several equivalent “lenses”.
Each lens emphasizes a different kind of structure.

#v(0.6em)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8em,

  block(
    fill: light-blue,
    radius: 6pt,
    inset: 0.75em,
  )[
    *Independent sets* $cal(I)$

    #v(0.3em)
    Main idea: feasible sets closed under taking subsets.

    #v(0.3em)
    *Exchange:* a smaller independent set can be augmented from a larger one.
  ],

  block(
    fill: light-blue,
    radius: 6pt,
    inset: 0.75em,
  )[
    *Bases* $cal(B)$

    #v(0.3em)
    Main idea: maximal feasible sets all have the same size.

    #v(0.3em)
    *Basis exchange:* swapping one element from one basis with a suitable element from another gives a basis again.
  ],

  block(
    fill: light-blue,
    radius: 6pt,
    inset: 0.75em,
  )[
    *Circuits* $cal(C)$

    #v(0.3em)
    Main idea: minimal dependent sets.

    #v(0.3em)
    *Elimination:* two circuits sharing an element imply another circuit after eliminating that element.
  ],

  block(
    fill: light-blue,
    radius: 6pt,
    inset: 0.75em,
  )[
    *Rank* $r$

    #v(0.3em)
    Main idea: dimension-like size of the largest independent subset.

    #v(0.3em)
    *Submodularity:*

    $r(A union B) + r(A inter B) lt.eq r(A) + r(B)$
  ],
)

#v(0.8em)

#block(
  fill: light-blue,
  radius: 6pt,
  inset: 0.75em,
)[
  *Closure* $"cl"$

  Main idea: span-like operator: which elements are forced by a set?

  #v(0.3em)
  *Mac Lane–Steinitz exchange:*

  $e in.not "cl"(A), e in "cl"(A union {f}) arrow.double f in "cl"(A union {e})$
]

#v(0.6em)

#bul[Different axiom systems are useful in different settings: circuits for graphic matroids, rank for linear algebra, bases for optimisation.]
#bul[The equivalences are constructive: each system can be converted into the others.]
