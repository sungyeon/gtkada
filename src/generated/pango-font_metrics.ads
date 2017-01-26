------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2017, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  <description>
--  A Pango.Font_Metrics.Pango_Font_Metrics structure holds the overall metric
--  information for a font (possibly restricted to a script). The fields of
--  this structure are private to implementations of a font backend. See the
--  documentation of the corresponding getters for documentation of their
--  meaning.
--
--  </description>
pragma Ada_2005;

pragma Warnings (Off, "*is already use-visible*");
with Glib; use Glib;

package Pango.Font_Metrics is

   type Pango_Font_Metrics is private;
   function From_Object_Free (B : access Pango_Font_Metrics) return Pango_Font_Metrics;
   pragma Inline (From_Object_Free);
   --  A Pango.Font_Metrics.Pango_Font_Metrics structure holds the overall
   --  metric information for a font (possibly restricted to a script). The
   --  fields of this structure are private to implementations of a font
   --  backend. See the documentation of the corresponding getters for
   --  documentation of their meaning.

   ------------------
   -- Constructors --
   ------------------

   procedure Gdk_New (Self : out Pango_Font_Metrics);
   --  Creates a new Pango.Font_Metrics.Pango_Font_Metrics structure. This is
   --  only for internal use by Pango backends and there is no public way to
   --  set the fields of the structure.

   function Pango_Font_Metrics_New return Pango_Font_Metrics;
   --  Creates a new Pango.Font_Metrics.Pango_Font_Metrics structure. This is
   --  only for internal use by Pango backends and there is no public way to
   --  set the fields of the structure.

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "pango_font_metrics_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Approximate_Char_Width
      (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Approximate_Char_Width, "pango_font_metrics_get_approximate_char_width");
   --  Gets the approximate character width for a font metrics structure. This
   --  is merely a representative value useful, for example, for determining
   --  the initial size for a window. Actual characters in text will be wider
   --  and narrower than this.

   function Get_Approximate_Digit_Width
      (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Approximate_Digit_Width, "pango_font_metrics_get_approximate_digit_width");
   --  Gets the approximate digit width for a font metrics structure. This is
   --  merely a representative value useful, for example, for determining the
   --  initial size for a window. Actual digits in text can be wider or
   --  narrower than this, though this value is generally somewhat more
   --  accurate than the result of
   --  Pango.Font_Metrics.Get_Approximate_Char_Width for digits.

   function Get_Ascent (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Ascent, "pango_font_metrics_get_ascent");
   --  Gets the ascent from a font metrics structure. The ascent is the
   --  distance from the baseline to the logical top of a line of text. (The
   --  logical top may be above or below the top of the actual drawn ink. It is
   --  necessary to lay out the text to figure where the ink will be.)

   function Get_Descent (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Descent, "pango_font_metrics_get_descent");
   --  Gets the descent from a font metrics structure. The descent is the
   --  distance from the baseline to the logical bottom of a line of text. (The
   --  logical bottom may be above or below the bottom of the actual drawn ink.
   --  It is necessary to lay out the text to figure where the ink will be.)

   function Get_Strikethrough_Position
      (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Strikethrough_Position, "pango_font_metrics_get_strikethrough_position");
   --  Gets the suggested position to draw the strikethrough. The value
   --  returned is the distance *above* the baseline of the top of the
   --  strikethrough.
   --  Since: gtk+ 1.6

   function Get_Strikethrough_Thickness
      (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Strikethrough_Thickness, "pango_font_metrics_get_strikethrough_thickness");
   --  Gets the suggested thickness to draw for the strikethrough.
   --  Since: gtk+ 1.6

   function Get_Underline_Position (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Underline_Position, "pango_font_metrics_get_underline_position");
   --  Gets the suggested position to draw the underline. The value returned
   --  is the distance *above* the baseline of the top of the underline. Since
   --  most fonts have underline positions beneath the baseline, this value is
   --  typically negative.
   --  Since: gtk+ 1.6

   function Get_Underline_Thickness (Self : Pango_Font_Metrics) return Gint;
   pragma Import (C, Get_Underline_Thickness, "pango_font_metrics_get_underline_thickness");
   --  Gets the suggested thickness to draw for the underline.
   --  Since: gtk+ 1.6

   function Ref (Self : Pango_Font_Metrics) return Pango_Font_Metrics;
   pragma Import (C, Ref, "pango_font_metrics_ref");
   --  Increase the reference count of a font metrics structure by one.

   procedure Unref (Self : Pango_Font_Metrics);
   pragma Import (C, Unref, "pango_font_metrics_unref");
   --  Decrease the reference count of a font metrics structure by one. If the
   --  result is zero, frees the structure and any associated memory.

private
type Pango_Font_Metrics is record
   Ref_Count : Guint;
   Ascent : Gint;
   Descent : Gint;
   Approximate_Char_Width : Gint;
   Approximate_Digit_Width : Gint;
   Underline_Position : Gint;
   Underline_Thickness : Gint;
   Strikethrough_Position : Gint;
   Strikethrough_Thickness : Gint;
end record;
pragma Convention (C, Pango_Font_Metrics);

end Pango.Font_Metrics;
