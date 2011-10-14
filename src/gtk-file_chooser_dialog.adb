-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                 Copyright (C) 2006-2011, AdaCore                  --
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

with Gtk.File_Chooser;   use Gtk.File_Chooser;
with Gtk.Window;         use Gtk.Window;

with Glib.Type_Conversion_Hooks;

package body Gtk.File_Chooser_Dialog is

   package Type_Conversion is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_File_Chooser_Dialog_Record);
   pragma Warnings (Off, Type_Conversion);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New
     (Dialog            : out Gtk_File_Chooser_Dialog;
      Title             : String;
      Parent            : Gtk.Window.Gtk_Window;
      Action            : Gtk.File_Chooser.File_Chooser_Action)
   is
   begin
      Dialog := new Gtk_File_Chooser_Dialog_Record;
      Initialize (Dialog, Title, Parent, Action);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Dialog            : access Gtk_File_Chooser_Dialog_Record'Class;
      Title             : String;
      Parent            : Gtk.Window.Gtk_Window;
      Action            : Gtk.File_Chooser.File_Chooser_Action)
   is
      function Internal
        (Title             : String;
         Parent            : System.Address;
         Action            : File_Chooser_Action)
         return System.Address;
      pragma Import (C, Internal, "ada_gtk_file_chooser_dialog_new");

      P : System.Address := System.Null_Address;
   begin
      if Parent /= null then
         P := Get_Object (Parent);
      end if;

      Set_Object (Dialog, Internal (Title & ASCII.NUL, P, Action));
   end Initialize;

end Gtk.File_Chooser_Dialog;
