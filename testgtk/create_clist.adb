-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
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

with Glib;                use Glib;
with Gdk;                 use Gdk;
with Gdk.Color;           use Gdk.Color;
with Gdk.Font;            use Gdk.Font;
with Gdk.Pixmap;          use Gdk.Pixmap;
with Gdk.Bitmap;          use Gdk.Bitmap;
with Gtk;                 use Gtk;
with Gtk.Box;             use Gtk.Box;
with Gtk.Button;          use Gtk.Button;
with Gtk.Check_Button;    use Gtk.Check_Button;
with Gtk.Clist;           use Gtk.Clist;
with Gtk.Enums;           use Gtk.Enums;
with Gtk.Label;           use Gtk.Label;
with Gtk.Option_Menu;     use Gtk.Option_Menu;
with Gtk.Radio_Menu_Item; use Gtk.Radio_Menu_Item;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Handlers;        use Gtk.Handlers;
with Gtk.Style;           use Gtk.Style;
with Gtk.Widget;          use Gtk.Widget;
with Gtkada.Types;        use Gtkada.Types;
with Common;              use Common;
with Interfaces.C.Strings;

package body Create_Clist is
   package IC renames Interfaces.C;
   package ICS renames Interfaces.C.Strings;

   package Clist_Cb is new Handlers.Callback (Gtk_Clist_Record);
   package Check_Cb is new Handlers.User_Callback
     (Gtk_Check_Button_Record, Gtk_Clist);

   use type Interfaces.C.size_t;

   Clist_Columns      : constant Interfaces.C.size_t := 12;
   Clist_Rows         : Integer := 0;
   Style1             : Gtk_Style;
   Style2             : Gtk_Style;
   Style3             : Gtk_Style;
   Clist_Omenu_Group  : Widget_Slist.GSlist;

   Titles : constant Chars_Ptr_Array (1 .. Clist_Columns):=
     (ICS.New_String ("Auto resize"),
      ICS.New_String ("Not resizable"),
      ICS.New_String ("Max width 100"),
      ICS.New_String ("Min Width 50"),
      ICS.New_String ("Hide column"),
      ICS.New_String ("Title 5"),
      ICS.New_String ("Title 6"),
      ICS.New_String ("Title 7"),
      ICS.New_String ("Title 8"),
      ICS.New_String ("Title 9"),
      ICS.New_String ("Title 10"),
      ICS.New_String ("Title 11"));
   --  Put at the library level to avoid having to allocate/free the
   --  memory each time "Run" is called...

   Items : constant Chars_Ptr_Array :=
     (ICS.New_String ("Single"),
      ICS.New_String ("Browse"),
      ICS.New_String ("Multiple"),
      ICS.New_String ("Extended"));

   ----------
   -- Help --
   ----------

   function Help return String is
   begin
      return "An @bGtk_Clist@B is like a @bGtk_List@B, except it shows the"
        & " information on multiple columns. You can have as many columns"
        & " as you want, each with its own information."
        & ASCII.LF
        & "Each line can have its own user_data, although the interface is"
        & " different from the standard interface. Some specific functions"
        & " are provided for this usage. The standard inheritance mechanism"
        & " does not work for rows in a clist, altough of course it does"
        & " work for the @bGtk_Clist@B itself.";
   end Help;

   ----------------
   -- Clear_List --
   ----------------

   procedure Clear_List (List : access Gtk_Clist_Record'Class) is
   begin
      Clear (List);
      Clist_Rows := 0;
   end Clear_List;

   ----------------------
   -- Remove_Selection --
   ----------------------

   procedure Remove_Selection (List : access Gtk_Clist_Record'Class) is
      use Gint_List;
      I : Gint;
   begin
      Freeze (List);
      loop
         exit when Length (Get_Selection (List)) = 0;
         Clist_Rows := Clist_Rows - 1;
         I := Get_Data (First (Get_Selection (List)));
         Remove (List, I);
         exit when Get_Selection_Mode (List) = Selection_Browse;
      end loop;

      Thaw (List);
   end Remove_Selection;

   -------------------
   -- Toggle_Titles --
   -------------------

   procedure Toggle_Titles (Button : access Gtk_Check_Button_Record'Class;
                            List : in Gtk_Clist) is
   begin
      if Get_Active (Button) then
         Column_Titles_Show (List);
      else
         Column_Titles_Hide (List);
      end if;
   end Toggle_Titles;

   ------------------------
   -- Toggle_Reorderable --
   ------------------------

   procedure Toggle_Reorderable (Button : access Gtk_Check_Button_Record'Class;
                                 List : in Gtk_Clist) is
   begin
      Set_Reorderable (List, Get_Active (Button));
   end Toggle_Reorderable;

   -------------
   -- Add1000 --
   -------------

   procedure Add1000 (List : access Gtk_Clist_Record'Class) is
      Pixmap : Gdk_Pixmap;
      Mask   : Gdk_Bitmap;
      Texts  : Chars_Ptr_Array (0 .. Clist_Columns - 1);
      Row    : Gint;
      Style  : Gtk_Style := Get_Style (List);

   begin
      Create_From_Xpm_D (Pixmap, Get_Clist_Window (List),
                         Mask, Get_White (Style),
                         Gtk_Mini_Xpm);
      for I in 4 .. Clist_Columns - 1 loop
         Texts (I) := ICS.New_String ("Column" & IC.size_t'Image (I));
      end loop;
      Texts (3) := ICS.Null_Ptr;
      Texts (1) := ICS.New_String ("Right");
      Texts (2) := ICS.New_String ("Center");
      Texts (0) := ICS.Null_Ptr;
      Freeze (List);

      for I in 0 .. 999 loop
         ICS.Free (Texts (0));
         Texts (0) := ICS.New_String ("CListRow" & Integer'Image (I));
         Row := Append (List, Texts);
         Set_Pixtext (List, Row, 3, "gtk+", 5, Pixmap, Mask);
      end loop;
      Clist_Rows := Clist_Rows + 1000;

      Free (Texts);

      Thaw (List);
      Unref (Pixmap);
      Unref (Mask);
   end Add1000;

   --------------
   -- Add10000 --
   --------------

   procedure Add10000 (List : access Gtk_Clist_Record'Class) is
      Texts  : Chars_Ptr_Array (0 .. Clist_Columns - 1);
      Row    : Gint;

   begin
      for I in 3 .. Clist_Columns - 1 loop
         Texts (I) := ICS.New_String ("Column" & IC.size_t'Image (I));
      end loop;
      Texts (1) := ICS.New_String ("Right");
      Texts (2) := ICS.New_String ("Center");
      Texts (0) := ICs.Null_Ptr;

      Freeze (List);
      for I in 0 .. 9999 loop
         Ics.Free (Texts (0));
         Texts (0) := ICS.New_String ("Row" & Integer'Image (I));
         Row := Append (List, Texts);
      end loop;
      Clist_Rows := Clist_Rows + 10000;
      Free (Texts);
      Thaw (List);
   end Add10000;

   ----------------
   -- Insert_Row --
   ----------------

   procedure Insert_Row (List : access Gtk_Clist_Record'Class) is
      Texts  : Chars_Ptr_Array (0 .. Clist_Columns - 1)
        := (ICS.New_String ("This"),
            ICS.New_String ("is an"),
            ICS.New_String ("inserted"),
            ICS.New_String ("row"),
            ICS.New_String ("This"),
            ICS.New_String ("is an"),
            ICS.New_String ("inserted"),
            ICS.New_String ("row"),
            ICS.New_String ("This"),
            ICS.New_String ("is an"),
            ICS.New_String ("inserted"),
            ICS.New_String ("row"));
      Col1 : Gdk_Color;
      Col2 : Gdk_Color;
      Row  : Gint;
      Font : Gdk_Font;
      Style : Gtk_Style := Get_Style (List);

   begin
      Row := Prepend (List, Texts);
      if not Gdk.Is_Created (Style1) then
         Set_Rgb (Col1, 0, 56000, 0);
         Set_Rgb (Col2, 32000, 0, 56000);

         --  Note that the memory allocated here is never freed in this
         --  small example!
         Style1 := Copy (Style);
         Set_Base (Style1, State_Normal, Col1);
         Set_Base (Style1, State_Selected, Col2);

         Style2 := Copy (Style);
         Set_Foreground (Style2, State_Normal, Col1);
         Set_Foreground (Style2, State_Selected, Col2);

         Style3 := Copy (Style);
         Set_Foreground (Style3, State_Normal, Col1);
         Set_Base (Style3, State_Normal, Col2);

         Load (Font, "-*-courier-medium-*-*-*-*-120-*-*-*-*-*-*");
         Set_Font (Style3, Font);
      end if;

      Set_Cell_Style (List, Row, 3, Style1);
      Set_Cell_Style (List, Row, 4, Style2);
      Set_Cell_Style (List, Row, 0, Style3);
      Clist_Rows := Clist_Rows + 1;
      Free (Texts);
   end Insert_Row;

   --------------------
   -- Undo_Selection --
   --------------------

   procedure Undo_Selection (List : access Gtk_Clist_Record'Class) is
   begin
      Gtk.Clist.Undo_Selection (List);
   end Undo_Selection;

   ---------------------
   -- Toggle_Sel_Mode --
   ---------------------

   procedure Toggle_Sel_Mode (List : access Gtk_Clist_Record'Class) is
      I : Integer := Selected_Button (Clist_Omenu_Group);

   begin
      Set_Selection_Mode (List, Gtk_Selection_Mode'Val (3 - I));
   end Toggle_Sel_Mode;

   ---------
   -- Run --
   ---------

   procedure Run (Frame : access Gtk.Frame.Gtk_Frame_Record'Class) is
      Texts     : Chars_Ptr_Array (0 .. Clist_Columns - 1);
      VBox,
        HBox    : Gtk_Box;
      Clist     : Gtk_CList;
      Button    : Gtk_Button;
      Label     : Gtk_Label;
      New_Row   : Gint;
      Scrolled  : Gtk_Scrolled_Window;
      Check     : Gtk_Check_Button;
      Omenu     : Gtk_Option_Menu;
      Col1      : Gdk_Color;
      Col2      : Gdk_Color;
      Style     : Gtk_Style;
      Font      : Gdk_Font;

   begin

      Clist_Rows := 0;
      Set_Label (Frame, "Clist");

      Gtk_New_Vbox (VBox, False, 0);
      Add (Frame, VBox);

      Gtk_New (Scrolled);
      Set_Border_Width (Scrolled, 5);
      Set_Policy (Scrolled, Policy_Automatic, Policy_Automatic);

      Gtk_New (Clist, Gint (Clist_Columns), Titles);
      Add (Scrolled, Clist);
      --  TBD: Callback for click column

      Gtk_New_Hbox (Hbox, False, 5);
      Set_Border_Width (Hbox, 5);
      Pack_Start (Vbox, Hbox, False, False, 0);

      Gtk_New (Button, "Insert Row");
      Pack_Start (HBox, Button, True, True, 0);
      Clist_Cb.Object_Connect (Button, "clicked",
                               Clist_Cb.To_Marshaller (Insert_Row'Access),
                               Slot_Object => Clist);

      Gtk_New (Button, "Add 1000 Rows with Pixmaps");
      Pack_Start (HBox, Button, True, True, 0);
      Clist_Cb.Object_Connect (Button, "clicked",
                               Clist_Cb.To_Marshaller (Add1000'Access),
                               Slot_Object => Clist);

      Gtk_New (Button, "Add 10000 Rows");
      Pack_Start (HBox, Button, True, True, 0);
      Clist_Cb.Object_Connect (Button, "clicked",
                               Clist_Cb.To_Marshaller (Add10000'Access),
                               Slot_Object => Clist);

      --  Second layer of buttons
      Gtk_New_Hbox (Hbox, False, 5);
      Set_Border_Width (Hbox, 5);
      Pack_Start (Vbox, Hbox, False, False, 0);

      Gtk_New (Button, "Clear List");
      Pack_Start (Hbox, Button, True, True, 0);
      Clist_Cb.Object_Connect (Button, "clicked",
                               Clist_Cb.To_Marshaller (Clear_List'Access),
                               Slot_Object => Clist);

      Gtk_New (Button, "Remove Selection");
      Pack_Start (Hbox, Button, True, True, 0);
      Clist_Cb.Object_Connect
        (Button, "clicked",
         Clist_Cb.To_Marshaller (Remove_Selection'Access),
         Slot_Object => Clist);

      Gtk_New (Button, "Undo Selection");
      Pack_Start (Hbox, Button, True, True, 0);
      Clist_Cb.Object_Connect
        (Button, "clicked",
         Clist_Cb.To_Marshaller (Undo_Selection'Access),
         Slot_Object => Clist);

      --  TBD??? Warning tests button

      --  Third layer of buttons
      Gtk_New_Hbox (Hbox, False, 5);
      Set_Border_Width (Hbox, 5);
      Pack_Start (Vbox, Hbox, False, False, 0);

      Gtk_New (Check, "Toggle title Buttons");
      Pack_Start (Hbox, Check, True, True, 0);
      Check_Cb.Connect (Check, "clicked",
                        Check_Cb.To_Marshaller (Toggle_Titles'Access),
                        Clist);
      Set_Active (Check, True);

      Gtk_New (Check, "Reorderable");
      Pack_Start (Hbox, Check, True, True, 0);
      Check_Cb.Connect
        (Check, "clicked",
         Check_Cb.To_Marshaller (Toggle_Reorderable'Access),
         Clist);
      Set_Active (Check, True);

      Gtk_New (Label, "Selection_Mode :");
      Pack_Start (Hbox, Label, False, True, 0);

      Clist_Omenu_Group := Widget_Slist.Null_List;
      Build_Option_Menu (Omenu, Clist_Omenu_Group, Items, 0, null);
      --  FIXME: Add the missing callback (instead of null).
      Pack_Start (Hbox, Omenu, False, True, 0);

      Pack_Start (Vbox, Scrolled, True, True, 0);
      Set_Row_Height (Clist, 18);
      Set_Usize (Clist, -1, 300);

      for I in 0 .. Clist_Columns - 1 loop
         Set_Column_Width (Clist, Gint (I), 80);
      end loop;

      Set_Column_Auto_Resize (Clist, 0, True);
      Set_Column_Resizeable (Clist, 1, False);
      Set_Column_Max_Width (Clist, 2, 100);
      Set_Column_Min_Width (Clist, 3, 50);
      Set_Selection_Mode (Clist, Selection_Extended);
      Set_Column_Justification (Clist, 1, Justify_Right);
      Set_Column_Justification (Clist, 2, Justify_Center);

      for I in 1 .. Clist_Columns - 1 loop
            Texts (I) := ICS.New_String ("Columns " & IC.size_t'Image (I));
      end loop;

      Set_Rgb (Col1, 56000, 0, 0);
      Set_Rgb (Col2, 0, 56000, 32000);

      Gtk_New (Style);
      Set_Foreground (Style, State_Normal, Col1);
      Set_Base (Style, State_Normal, Col2);
      Load (Font, "-adobe-helvetica-bold-r-*-*-*-140-*-*-*-*-*-*");
      Set_Font (Style, Font);

      for I in Gint'(0) .. 9 loop
         Texts (0) := ICS.New_String ("ClistRow " & Integer'Image (Clist_Rows));
         Clist_Rows := Clist_Rows + 1;
         New_Row := Append (Clist, Texts);
         ICS.Free (Texts (0));
         if I mod 4 = 2 then
            Set_Row_Style (Clist, I, Style);
         else
            Set_Cell_Style (Clist, I, I mod 4, Style);
         end if;
      end loop;

      Show_All (Frame);
   end Run;

end Create_Clist;

