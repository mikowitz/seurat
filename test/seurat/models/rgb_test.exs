defmodule Seurat.Models.RgbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.{Rgb, Xyz}
  doctest Rgb

  describe "conversions" do
    test "to RGB" do
      test_conversion(ColorMine, :rgb, :rgb, Rgb)
    end

    test "to HSV" do
      test_conversion(ColorMine, :hsv, :rgb, Seurat.Models.Hsv)
    end

    test "to HSL" do
      test_conversion(ColorMine, :hsl, :rgb, Seurat.Models.Hsl)
    end

    test "to HWB" do
      test_conversion(ColorMine, :hwb, :rgb, Seurat.Models.Hwb)
    end

    test "to XYZ" do
      test_conversion(ColorMine, :xyz, :rgb, Seurat.Models.Xyz)
    end
  end

  describe "adapting to different RGB profiles" do
    test "from sRGB" do
      srgb = Rgb.new(0.5, 0, 1)

      pro_photo = Rgb.new(0.4053, 0.0773, 0.8741, :pro_photo)
      adobe = Rgb.new(0.3576, 0, 0.9588, :adobe)
      apple = Rgb.new(0.4563, -0.0285, 1.0325, :apple)
      wide_gamut = Rgb.new(0.2993, 0.1091, 0.9245, :wide_gamut)

      assert_colors_equal(pro_photo, Rgb.into(srgb, :pro_photo))
      assert_colors_equal(adobe, Rgb.into(srgb, :adobe))
      assert_colors_equal(apple, Rgb.into(srgb, :apple))
      assert_colors_equal(wide_gamut, Rgb.into(srgb, :wide_gamut))
    end

    test "from Pro Photo" do
      pro_photo = Rgb.new(0.5, 0, 1, :pro_photo)

      srgb = Rgb.new(0.7102, -0.1172, 1.1573)
      wide_gamut = Rgb.new(0.3769, 0.0399, 1.0633, :wide_gamut)
      apple = Rgb.new(0.6419, -0.1581, 1.1986, :apple)
      adobe = Rgb.new(0.4746, -0.1173, 1.1048, :adobe)

      assert_colors_equal(srgb, Rgb.into(pro_photo, :srgb))
      assert_colors_equal(wide_gamut, Rgb.into(pro_photo, :wide_gamut))
      assert_colors_equal(apple, Rgb.into(pro_photo, :apple))
      assert_colors_equal(adobe, Rgb.into(pro_photo, :adobe))
    end

    test "from Adobe" do
      adobe = Rgb.new(0.5, 0, 1, :adobe)

      srgb = Rgb.new(0.6991, 0, 1.0429)

      assert_colors_equal(srgb, Rgb.into(adobe, :srgb))
    end

    test "from Apple" do
      apple = Rgb.new(0.5, 0, 1, :apple)

      wide_gamut = Rgb.new(0.3366, 0.135, 0.8988, :wide_gamut)

      assert_colors_equal(wide_gamut, Rgb.into(apple, :wide_gamut))
    end

    test "from Wide Gamut" do
      wide_gamut = Rgb.new(0.5, 0, 1, :wide_gamut)

      adobe = Rgb.new(0.6378, -0.1887, 1.0379, :adobe)

      assert_colors_equal(adobe, Rgb.into(wide_gamut, :adobe))
    end
  end

  describe "converting from different profiles to XYZ" do
    test "sRGB" do
      rgb = Rgb.new(0.5, 0, 1, :srgb)

      expected = Xyz.new(0.26872, 0.117696, 0.954442, :d65)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end

    test "Adobe RGB" do
      rgb = Rgb.new(0.5, 0, 1, :adobe)

      expected = Xyz.new(0.313704, 0.139994, 0.996992, :d65)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end

    test "ProPhoto RGB" do
      rgb = Rgb.new(0.5, 0, 1, :pro_photo)

      expected = Xyz.new(0.260425, 0.082804, 0.825210, :d50)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.05)
    end

    test "Wide Gamut RGB" do
      rgb = Rgb.new(0.5, 0, 1, :wide_gamut)

      expected = Xyz.new(0.303037, 0.073066, 0.773429, :d50)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end
  end
end
