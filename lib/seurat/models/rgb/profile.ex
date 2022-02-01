defmodule Seurat.Models.Rgb.Profile do
  @moduledoc """
  Provides an abstract basis for an RGB colorspace profile.

  ## Linear vs non-linear RGB

  In digital images, colors are often stored in a gamma corrected -- converted
  using a non-linear transfer function into a format like sRGB (Standard RGB) --
  format. This is done both for compression, and to account for the fact that
  the output from the electron gun in older CRT monitors was non-linear. It also
  accounts for the fact that human eyes are more sensitive to color variation
  at low intensities (near black) than at high intensities (near white).

  This non-linearity means that operations (addition, multiplication,
  interpolaction, etc.) on colors that have have been gamma corrected will not
  return expected results. In order to modify RGB colors, the gamma correction
  must be reversed.

  For example, if you want to modify colors in an image you would follow these
  steps

  1. decode color pixel data from the image
  2. reverse the gamma correction, converting to linear sRGB
  3. perform your modification operations
  4. reapply the gamma correction
  5. encode color data back into an image format to be stored

  ## RGB profiles

  An RGB colorspace profile is defined by two pieces of data:

  1. Its primaries (canonical values for "red", "green" and "blue", defined as
    [`Yxy`](`Seurat.Models.Yxy`) colors)
  2. Its reference white, or [white point](`Seurat.WhitePoint`)

  Seurat provides definitions for the following common RGB profiles

  - Adobe RGB (1998) - a colorspace developed by Adobe in 1998, designed to
    encompass most of the colors achievable by CMYK color printers, but using
    RGB primary colors on computer displays
  - ProPhoto RGB - also known as ROMM RGB, it was developed by Kodak to have a
    large gamut with photographic output in mind. Because of its gamut (wider
    even than Wide Gamut RGB), primaries and white point, approximately 13% of
    this colorspace -- including its green and blue primaries -- is made up of
    [imaginary colors](https://en.wikipedia.org/wiki/Impossible_color#Imaginary_colors)
  - sRGB - developed by HP and Microsoft in 1996 for use on monitors, printers,
    and the nascent internet, and it is still the defined standard colorspace
    for the web, and the assumed colorspace for images that are not otherwise
    tagged. It has the smallest gamut, making it impractical for high quality
    photo work, but excellent for portability and web images/design.
  - Wide Gamut RGB - another RGB colorspace developed by Adobe. As its name
    suggests, it is able to display and store a winder range of colors than
    Adobe RGB or sRGB

  When people talk about "RGB", especially in digital and web design, they
  almost always mean "sRGB", so that is the RGB colorspace `Seurat` adopts as
  default. This allows users to use the library as easily as possible, while
  still providing more complexity if required.

  For example, defining a new RGB color with no profile specified will
  result in an sRGB color

      iex> Rgb.new(0.5, 0, 1)
      #Seurat.Models.Rgb<0.5, 0.0, 1.0 (sRGB)>

  But a different RGB profile can be provided, such as the 1998 Adobe RGB

      iex> Rgb.new(0.5, 0, 1, :adobe)
      #Seurat.Models.Rgb<0.5, 0.0, 1.0 (Adobe RGB)>

  """
end
