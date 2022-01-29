defmodule Seurat.Utils.Matrix do
  def multiply(
        [[a1, b1, c1], [d1, e1, f1], [g1, h1, i1]],
        [[a2, b2, c2], [d2, e2, f2], [g2, h2, i2]]
      ) do
    [
      [
        a1 * a2 + b1 * d2 + c1 * g2,
        a1 * b2 + b1 * e2 + c1 * h2,
        a1 * c2 + b1 * f2 + c1 * i2
      ],
      [
        d1 * a2 + e1 * d2 + f1 * g2,
        d1 * b2 + e1 * e2 + f1 * h2,
        d1 * c2 + e1 * f2 + f1 * i2
      ],
      [
        g1 * a2 + h1 * d2 + i1 * g2,
        g1 * b2 + h1 * e2 + i1 * h2,
        g1 * c2 + h1 * f2 + i1 * i2
      ]
    ]
  end

  def mulitply_vector([x, y, z], [[a, b, c], [d, e, f], [g, h, i]]) do
    [
      x * a + y * b + z * c,
      x * d + y * e + z * f,
      x * g + y * h + z * i
    ]
  end

  def invert([[a, b, c], [d, e, f], [g, h, i]]) do
    [ma, mb, mc] = [e * i - f * h, -1 * (d * i - f * g), d * h - e * g]
    fac = 1 / (a * ma + b * mb + c * mc)

    [
      [ma * fac, -1 * (b * i - c * h) * fac, (b * f - c * e) * fac],
      [mb * fac, (a * i - c * g) * fac, -1 * (a * f - c * d) * fac],
      [mc * fac, -1 * (a * h - b * g) * fac, (a * e - b * d) * fac]
    ]
  end

  def identity, do: [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
end
