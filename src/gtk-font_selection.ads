-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2001 ACT-Europe                 --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

--  <description>
--  This widget provides a nice way for the user of your application to
--  select fonts.
--  It first searches on your system for the list of fonts available, and
--  displays a set of boxes to select them based on their name, their
--  weight, their size, etc.
--  This widget is provided in two forms, one widget that can be embedded
--  in any container, a Gtk_Font_Selection, whereas the other one comes
--  directly in its own separate window (to be popped up as a dialog).
--
--  Some filters can be applied to the widget, when you want the user to
--  select only a font only among a specific subset (like bitmap or
--  true-type fonts for instance).
--  There are two kinds of filters: a base filter, set in your application
--  and that the user can not change; a user filter that can be modified
--  interactively by the user.
--
--  </description>
--  <c_version>1.3.6</c_version>

with Gdk.Font;
with Gtk.Box;
with Gtk.Button;
with Gtk.Dialog;

package Gtk.Font_Selection is

   type Gtk_Font_Selection_Dialog_Record is new
     Gtk.Dialog.Gtk_Dialog_Record with private;
   type Gtk_Font_Selection_Dialog is access all
     Gtk_Font_Selection_Dialog_Record'Class;

   type Gtk_Font_Selection_Record is new
     Gtk.Box.Gtk_Box_Record with private;
   type Gtk_Font_Selection is access all Gtk_Font_Selection_Record'Class;

   ------------------------------
   -- Font_Selection functions --
   ------------------------------

   procedure Gtk_New (Widget : out Gtk_Font_Selection);
   --  Create a new font selection widget.
   --  It can be added to any existing container.

   procedure Initialize (Widget : access Gtk_Font_Selection_Record'Class);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Font_Selection.

   function Get_Font_Name
     (Fontsel : access Gtk_Font_Selection_Record) return String;
   --  Return the name of the font selected by the user.
   --  It returns an empty string if not font is selected.
   --  The string has the same format as excepted in the Gdk.Font package.
   --  This is also the standard format on X11 systems.

   function Get_Font
     (Fontsel : access Gtk_Font_Selection_Record) return Gdk.Font.Gdk_Font;
   --  Allocate and return the font selected by the user.
   --  This newly created font can be used as is by all the drawing functions
   --  in the Gdk.Drawable package.
   --  If not font has been selected, Gdk.Font.Null_Font is returned.

   function Set_Font_Name
     (Fontsel  : access Gtk_Font_Selection_Record;
      Fontname : String) return Boolean;
   --  Set the name and attributes of the selected font in Fontsel.
   --  Fontname should have the standard format on X11 systems, that fully
   --  describe the family, weight, size, slant, etc. of the font.

   function Get_Preview_Text
     (Fontsel : access Gtk_Font_Selection_Record) return String;
   --  Return the string used to preview the selected font in the dialog.

   procedure Set_Preview_Text
     (Fontsel : access Gtk_Font_Selection_Record; Text : String);
   --  Set the string to use to preview the selected font.

   -------------------------------------
   -- Font_Selection_Dialog functions --
   -------------------------------------

   procedure Gtk_New (Widget : out Gtk_Font_Selection_Dialog; Title : String);
   --  Create a new dialog to select a font.
   --  The font selection widget has its own window, whose title is chosen
   --  by Title.

   procedure Initialize
     (Widget : access Gtk_Font_Selection_Dialog_Record'Class; Title : String);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Dialog_Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Font_Selection_Dialog.

   function Get_Font_Name
     (Fsd : access Gtk_Font_Selection_Dialog_Record) return String;
   --  Return the name of the font selected by the user.
   --  It returns an empty string if not font is selected.
   --  The string has the same format as excepted in the Gdk.Font package.
   --  This is also the standard format on X11 systems.

   function Get_Font
     (Fsd : access Gtk_Font_Selection_Dialog_Record) return Gdk.Font.Gdk_Font;
   --  Allocate and return the font selected by the user.
   --  This newly created font can be used as is by all the drawing functions
   --  in the Gdk.Drawable package.
   --  If not font has been selected, Gdk.Font.Null_Font is returned.

   function Set_Font_Name
     (Fsd      : access Gtk_Font_Selection_Dialog_Record;
      Fontname : String) return Boolean;
   --  Set the name and attributes of the selected font in Fontsel.
   --  Fontname should have the standard format on X11 systems, that fully
   --  describe the family, weight, size, slant, etc. of the font.

   function Get_Preview_Text
     (Fsd : access Gtk_Font_Selection_Dialog_Record) return String;
   --  Return the string used to preview the selected font in the dialog.

   procedure Set_Preview_Text
     (Fsd : access Gtk_Font_Selection_Dialog_Record; Text : String);
   --  Set the string to use to preview the selected font.

   function Get_Cancel_Button
     (Fsd : access Gtk_Font_Selection_Dialog_Record)
      return Gtk.Button.Gtk_Button;
   --  Return the Id of the cancel button of the dialog.
   --  You can use this to set up a callback on that button.
   --  The callback should close the dialog, and ignore any value that has been
   --  set in it.

   function Get_OK_Button
     (Fsd : access Gtk_Font_Selection_Dialog_Record)
      return Gtk.Button.Gtk_Button;
   --  Return the Id of the Ok button.
   --  The callback set on this button should close the dialog if the selected
   --  font is valid, and do whatever if should with it.

   function Get_Apply_Button
     (Fsd : access Gtk_Font_Selection_Dialog_Record)
      return Gtk.Button.Gtk_Button;
   --  Return the Id of the Apply button.
   --  The callback on this button should temporarily apply the font, but
   --  should be able to cancel its effect if the Cancel button is selected.

   ----------------
   -- Properties --
   ----------------

   --  <properties>
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties.
   --
   --  </properties>

   -------------
   -- Signals --
   -------------

   --  <signals>
   --  The following new signals are defined for this widget:
   --  </signals>

private
   type Gtk_Font_Selection_Dialog_Record is new
     Gtk.Dialog.Gtk_Dialog_Record with null record;

   type Gtk_Font_Selection_Record is new
     Gtk.Box.Gtk_Box_Record with null record;

   pragma Import (C, Get_Type, "gtk_font_selection_get_type");
   pragma Import (C, Dialog_Get_Type, "gtk_font_selection_dialog_get_type");

end Gtk.Font_Selection;
