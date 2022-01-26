defmodule Seurat.Conversions.HsluvHelpers do
  @e 216 / 24389
  @k 24389 / 27
  @m [
    [3.240969941904521, -1.537383177570093, -0.498610760293],
    [-0.96924363628087, 1.87596750150772, 0.041555057407175],
    [0.055630079696993, -0.20397695888897, 1.056971514242878]
  ]

  def get_bounds(l) do
    sub1 = :math.pow(l + 16, 3) / 1_560_896
    sub2 = if sub1 > @e, do: sub1, else: l / @k

    line = fn c, t ->
      [m1, m2, m3] = Enum.at(@m, c)

      top1 = (284_517 * m1 - 94839 * m3) * sub2
      top2 = (838_422 * m3 + 769_860 * m2 + 731_718 * m1) * l * sub2 - 769_860 * t * l
      bottom = (632_260 * m3 - 126_452 * m2) * sub2 + 126_452 * t

      {top1 / bottom, top2 / bottom}
    end

    for c <- 0..2, t <- 0..1 do
      line.(c, t)
    end
  end

  def max_chroma_at_hue(bounds, hue) do
    min_chroma = 1.7976931348623157e+308
    h = degs_to_rads(hue)

    Enum.reduce(bounds, min_chroma, fn bound, min_c ->
      case intersect_length_at_angle(bound, h) do
        nil -> min_c
        t when t >= 0 and min_c > t -> t
        _ -> min_c
      end
    end)
  end

  def degs_to_rads(deg), do: deg / 360 * :math.pi() * 2

  defp intersect_length_at_angle({slope, intercept}, theta) do
    sin_theta = :math.sin(theta)
    cos_theta = :math.cos(theta)

    denom = sin_theta - slope * cos_theta

    if abs(denom) > 1.0e-6, do: intercept / denom, else: nil
  end
end
