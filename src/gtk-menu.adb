-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-2000                       --
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

with System;
with Gdk;            use Gdk;
with Gtk.Menu_Item;  use Gtk.Menu_Item;
with Gtk.Menu_Shell; use Gtk.Menu_Shell;
with Gtk.Util;       use Gtk.Util;
with Gtk.Object;     use Gtk.Object;

package body Gtk.Menu is

   ------------
   -- Append --
   ------------

   procedure Append
     (Menu  : access Gtk_Menu_Record;
      Child : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is
      procedure Internal (Menu  : System.Address;
                          Child : System.Address);
      pragma Import (C, Internal, "gtk_menu_append");
   begin
      Internal (Get_Object (Menu), Get_Object (Child));
   end Append;

   ----------------------
   -- Attach_To_Widget --
   ----------------------

   procedure Attach_To_Widget
     (Menu          : access Gtk_Menu_Record;
      Attach_Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Detacher      : in Gtk_Menu_Detach_Func)
   is
      procedure Internal (Menu          : System.Address;
                          Attach_Widget : System.Address;
                          Detacher      : Gtk_Menu_Detach_Func);
      pragma Import (C, Internal, "gtk_menu_attach_to_widget");
   begin
      Internal (Get_Object (Menu), Get_Object (Attach_Widget), Detacher);
   end Attach_To_Widget;

   ------------
   -- Detach --
   ------------

   procedure Detach (Menu : access Gtk_Menu_Record)
   is
      procedure Internal (Menu : System.Address);
      pragma Import (C, Internal, "gtk_menu_detach");
   begin
      Internal (Get_Object (Menu));
   end Detach;

   --------------------------------
   --  Ensure_Uline_Accel_Group  --
   --------------------------------

   function Ensure_Uline_Accel_Group (Menu : access Gtk_Menu_Record)
                                      return Accel_Group.Gtk_Accel_Group is
      function Internal (Menu : in System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_menu_ensure_uline_accel_group");
      Result : Accel_Group.Gtk_Accel_Group;
   begin
      Set_Object (Result, Internal (Get_Object (Menu)));
      return Result;
   end Ensure_Uline_Accel_Group;

   -----------------------
   --  Get_Accel_Group  --
   -----------------------

   function Get_Accel_Group (Menu : access Gtk_Menu_Record)
                            return Accel_Group.Gtk_Accel_Group is
      function Internal (Menu : in System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_menu_get_accel_group");
      Result : Accel_Group.Gtk_Accel_Group;
   begin
      Set_Object (Result, Internal (Get_Object (Menu)));
      return Result;
   end Get_Accel_Group;

   ----------------
   -- Get_Active --
   ----------------

   function Get_Active (Menu : access Gtk_Menu_Record)
                        return Gtk.Menu_Item.Gtk_Menu_Item
   is
      function Internal (Menu : System.Address)
                         return System.Address;
      pragma Import (C, Internal, "gtk_menu_get_active");
      Stub : Gtk.Menu_Item.Gtk_Menu_Item_Record;
   begin
      return Gtk.Menu_Item.Gtk_Menu_Item
        (Get_User_Data (Internal (Get_Object (Menu)), Stub));
   end Get_Active;

   -----------------------
   -- Get_Attach_Widget --
   -----------------------

   function Get_Attach_Widget (Menu : access Gtk_Menu_Record)
                               return Gtk.Widget.Gtk_Widget
   is
      function Internal (Menu : System.Address)
                         return System.Address;
      pragma Import (C, Internal, "gtk_menu_get_attach_widget");
      Stub : Gtk.Widget.Gtk_Widget_Record;
   begin
      return Gtk.Widget.Gtk_Widget
        (Get_User_Data (Internal (Get_Object (Menu)), Stub));
   end Get_Attach_Widget;

   -------------
   -- Get_New --
   -------------

   procedure Gtk_New (Widget : out Gtk_Menu)
   is
   begin
      Widget := new Gtk_Menu_Record;
      Initialize (Widget);
   end Gtk_New;

   -----------------------------
   --  Get_Uline_Accel_Group  --
   -----------------------------

   function Get_Uline_Accel_Group (Menu : access Gtk_Menu_Record)
                                   return Accel_Group.Gtk_Accel_Group is
      function Internal (Menu : in System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_menu_get_uline_accel_group");
      Result : Accel_Group.Gtk_Accel_Group;
   begin
      Set_Object (Result, Internal (Get_Object (Menu)));
      return Result;
   end Get_Uline_Accel_Group;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Widget : access Gtk_Menu_Record'Class)
   is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_menu_new");
   begin
      Set_Object (Widget, Internal);
      Initialize_User_Data (Widget);
   end Initialize;

   ------------
   -- Insert --
   ------------

   procedure Insert
     (Menu     : access Gtk_Menu_Record;
      Child    : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Position : in Gint := 0)
   is
      procedure Internal (Menu     : System.Address;
                          Child    : System.Address;
                          Position : Gint);
      pragma Import (C, Internal, "gtk_menu_insert");
   begin
      Internal (Get_Object (Menu), Get_Object (Child), Position);
   end Insert;

   -------------
   -- Popdown --
   -------------

   procedure Popdown (Menu : access Gtk_Menu_Record)
   is
      procedure Internal (Menu : System.Address);
      pragma Import (C, Internal, "gtk_menu_popdown");
   begin
      Internal (Get_Object (Menu));
   end Popdown;

   -------------
   -- Prepend --
   -------------

   procedure Prepend
     (Menu  : access Gtk_Menu_Record;
      Child : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is
      procedure Internal (Menu  : System.Address;
                          Child : System.Address);
      pragma Import (C, Internal, "gtk_menu_prepend");
   begin
      Internal (Get_Object (Menu), Get_Object (Child));
   end Prepend;


   ---------------------
   --  Reorder_Child  --
   ---------------------

   procedure Reorder_Child
     (Menu     : access Gtk_Menu_Record;
      Child    : in     Gtk.Widget.Gtk_Widget_Record'Class;
      Position : in     Gint) is
      procedure Internal (Menu     : in System.Address;
                          Child    : in System.Address;
                          Position : in Gint);
      pragma Import (C, Internal, "gtk_menu_reorder_child");
   begin
      Internal (Get_Object (Menu), Get_Object (Child), Position);
   end Reorder_Child;

   ------------------
   --  Reposition  --
   ------------------

   procedure Reposition (Menu : access Gtk_Menu_Record) is
      procedure Internal (Menu : in System.Address);
      pragma Import (C, Internal, "gtk_menu_reposition");
   begin
      Internal (Get_Object (Menu));
   end Reposition;

   -----------------------
   --  Set_Accel_Group  --
   -----------------------

   procedure Set_Accel_Group
      (Menu    : access Gtk_Menu_Record;
       Accel   : access Gtk.Accel_Group.Gtk_Accel_Group'Class) is
      procedure Internal (Menu        : in System.Address;
                          Accel_Group : in System.Address);
      pragma Import (C, Internal, "gtk_menu_set_accel_group");
   begin
      Internal (Get_Object (Menu), Get_Object (Accel));
   end Set_Accel_Group;


   ----------------
   -- Set_Active --
   ----------------

   procedure Set_Active
     (Menu  : access Gtk_Menu_Record;
      Index : in Guint)
   is
      procedure Internal (Menu  : System.Address;
                          Index : Guint);
      pragma Import (C, Internal, "gtk_menu_set_active");
   begin
      Internal (Get_Object (Menu), Index);
   end Set_Active;


   -----------------
   --  Set_Title  --
   -----------------

   procedure Set_Title (Menu  : access Gtk_Menu_Record;
                        Title : in     String) is
      procedure Internal (Menu  : in System.Address;
                          Title : in String);
      pragma Import (C, Internal, "gtk_menu_set_title");
   begin
      Internal (Get_Object (Menu), Title & ASCII.NUL);
   end Set_Title;


   -------------------------
   --  Set_Tearoff_State  --
   -------------------------

   procedure Set_Tearoff_State (Menu     : access Gtk_Menu_Record;
                                Torn_Off : in     Boolean) is
      procedure Internal (Menu     : in System.Address;
                          Torn_Off : in Gboolean);
      pragma Import (C, Internal, "gtk_menu_set_tearoff_state");
   begin
      Internal (Get_Object (Menu), To_Gboolean (Torn_Off));
   end Set_Tearoff_State;

   -----------
   -- Popup --
   -----------

   procedure Popup
     (Menu              : access Gtk_Menu_Record;
      Parent_Menu_Shell : in Gtk.Menu_Shell.Gtk_Menu_Shell := null;
      Parent_Menu_Item  : in Gtk.Menu_Item.Gtk_Menu_Item := null;
      Func              : in Gtk_Menu_Position_Func := null;
      Button            : in Guint := 1;
      Activate_Time     : in Guint32 := 0)
   is
      procedure Internal (Menu          : System.Address;
                          Parent_M      : System.Address;
                          Parent_I      : System.Address;
                          Func          : Gtk_Menu_Position_Func;
                          Data          : System.Address;
                          Button        : Guint;
                          Activate_Time : Guint32);
      pragma Import (C, Internal, "gtk_menu_popup");

      Parent_Shell : System.Address := System.Null_Address;
      Parent_Item  : System.Address := System.Null_Address;
   begin
      if Parent_Menu_Shell /= null then
         Parent_Shell := Get_Object (Parent_Menu_Shell);
      end if;
      if Parent_Menu_Item /= null then
         Parent_Item := Get_Object (Parent_Menu_Item);
      end if;

      Internal (Get_Object (Menu), Parent_Shell, Parent_Item,
                Func, System.Null_Address, Button, Activate_Time);
   end Popup;

   ---------------------------------------
   -- User_Menu_Popup (generic package) --
   ---------------------------------------

   package body User_Menu_Popup is

      -----------
      -- Popup --
      -----------

      procedure Popup
        (Menu              : access Gtk_Menu_Record;
         Data              : access Data_Type;
         Parent_Menu_Shell : in Gtk.Menu_Shell.Gtk_Menu_Shell := null;
         Parent_Menu_Item  : in Gtk.Menu_Item.Gtk_Menu_Item := null;
         Func              : in Gtk_Menu_Position_Func := null;
         Button            : in Guint := 1;
         Activate_Time     : in Guint32 := 0)
      is
         procedure Internal (Menu          : System.Address;
                             Parent_M      : System.Address;
                             Parent_I      : System.Address;
                             Func          : Gtk_Menu_Position_Func;
                             Data          : System.Address;
                             Button        : Guint;
                             Activate_Time : Guint32);
         pragma Import (C, Internal, "gtk_menu_popup");

         Parent_Shell : System.Address := System.Null_Address;
         Parent_Item  : System.Address := System.Null_Address;
      begin
         if Parent_Menu_Shell /= null then
            Parent_Shell := Get_Object (Parent_Menu_Shell);
         end if;
         if Parent_Menu_Item /= null then
            Parent_Item := Get_Object (Parent_Menu_Item);
         end if;

         Internal (Get_Object (Menu),
                   Get_Object (Parent_Menu_Shell),
                   Get_Object (Parent_Menu_Item),
                   Func,
                   Data.all'Address,
                   Button,
                   Activate_Time);
      end Popup;
   end User_Menu_Popup;

   --------------
   -- Generate --
   --------------

   procedure Generate (N    : in Node_Ptr;
                       File : in File_Type) is
      S : String_Ptr := Get_Field (N.Parent, "class");
   begin
      Gen_New (N, "Menu", File => File);

      if S /= null and then S.all = "GtkMenuItem" then
         Gen_Call_Child (N, null, "Menu_Item", "Set_Submenu", File => File);
         N.Specific_Data.Has_Container := True;
      end if;

      Menu_Shell.Generate (N, File);
   end Generate;

   procedure Generate (Menu : in out Gtk_Object;
                       N    : in Node_Ptr) is
      S : String_Ptr := Get_Field (N.Parent, "class");
   begin
      if not N.Specific_Data.Created then
         Gtk_New (Gtk_Menu (Menu));
         Set_Object (Get_Field (N, "name"), Menu);
         N.Specific_Data.Created := True;
      end if;

      if S /= null and then S.all = "GtkMenuItem" then
         Menu_Item.Set_Submenu
           (Gtk_Menu_Item (Get_Object (Get_Field (N.Parent, "name"))),
            Widget.Gtk_Widget (Menu));
         N.Specific_Data.Has_Container := True;
      end if;

      Menu_Shell.Generate (Menu, N);
   end Generate;

end Gtk.Menu;
