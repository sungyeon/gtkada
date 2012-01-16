------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
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

pragma Ada_05;
--  <description>
--  A Gtk_Assistant is a widget used to represent a generally complex
--  operation split into several steps, guiding the user through its pages and
--  controlling the page flow to collect the necessary data.
--
--  </description>
--  <group>Windows</group>
--  <testgtk>create_assistant.adb</testgtk>

pragma Warnings (Off, "*is already use-visible*");
with Gdk.Pixbuf;    use Gdk.Pixbuf;
with Glib;          use Glib;
with Glib.Types;    use Glib.Types;
with Gtk.Buildable; use Gtk.Buildable;
with Gtk.Widget;    use Gtk.Widget;
with Gtk.Window;    use Gtk.Window;

package Gtk.Assistant is

   type Gtk_Assistant_Record is new Gtk_Window_Record with null record;
   type Gtk_Assistant is access all Gtk_Assistant_Record'Class;

   type Gtk_Assistant_Page_Type is
        (Gtk_Assistant_Page_Content,
         Gtk_Assistant_Page_Intro,
         Gtk_Assistant_Page_Confirm,
         Gtk_Assistant_Page_Summary,
         Gtk_Assistant_Page_Progress);
      --  Definition of various page types.  See Get_Page_Type/Set_Page_Type
      --  for more info.


      type Gtk_Assistant_Page_Func is access function (Current_Page : Gint) return Gint;
      --  A function used by Gtk.Assistant.Set_Forward_Page_Func to know which is
      --  the next page given a current one. It's called both for computing the
      --  next page when the user presses the "forward" button and for handling
      --  the behavior of the "last" button.
      --  "current_page": The page number used to calculate the next page.

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Assistant : out Gtk_Assistant);
   procedure Initialize (Assistant : access Gtk_Assistant_Record'Class);
   --  Creates a new Gtk.Assistant.Gtk_Assistant.
   --  Since: gtk+ 2.10

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_assistant_get_type");

   -------------
   -- Methods --
   -------------

   procedure Add_Action_Widget
      (Assistant : access Gtk_Assistant_Record;
       Child     : access Gtk.Widget.Gtk_Widget_Record'Class);
   --  Adds a widget to the action area of a Gtk.Assistant.Gtk_Assistant.
   --  Since: gtk+ 2.10
   --  "child": a Gtk.Widget.Gtk_Widget

   function Append_Page
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class) return Gint;
   --  Appends a page to the Assistant.
   --  Since: gtk+ 2.10
   --  "page": a Gtk.Widget.Gtk_Widget

   procedure Commit (Assistant : access Gtk_Assistant_Record);
   --  Erases the visited page history so the back button is not shown on the
   --  current page, and removes the cancel button from subsequent pages.
   --  Use this when the information provided up to the current page is
   --  hereafter deemed permanent and cannot be modified or undone. For
   --  example, showing a progress page to track a long-running, unreversible
   --  operation after the user has clicked apply on a confirmation page.
   --  Since: gtk+ 2.22

   function Get_Current_Page
      (Assistant : access Gtk_Assistant_Record) return Gint;
   procedure Set_Current_Page
      (Assistant : access Gtk_Assistant_Record;
       Page_Num  : Gint);
   --  Switches the page to Page_Num.
   --  Note that this will only be necessary in custom buttons, as the
   --  Assistant flow can be set with Gtk.Assistant.Set_Forward_Page_Func.
   --  Since: gtk+ 2.10
   --  "page_num": index of the page to switch to, starting from 0. If
   --  negative, the last page will be used. If greater than the number of
   --  pages in the Assistant, nothing will be done.

   function Get_N_Pages
      (Assistant : access Gtk_Assistant_Record) return Gint;
   --  Returns the number of pages in the Assistant
   --  Since: gtk+ 2.10

   function Get_Nth_Page
      (Assistant : access Gtk_Assistant_Record;
       Page_Num  : Gint) return Gtk.Widget.Gtk_Widget;
   --  Returns the child widget contained in page number Page_Num.
   --  if Page_Num is out of bounds
   --  Since: gtk+ 2.10
   --  "page_num": the index of a page in the Assistant, or -1 to get the last
   --  page

   function Get_Page_Complete
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class) return Boolean;
   procedure Set_Page_Complete
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       Complete  : Boolean);
   --  Sets whether Page contents are complete.
   --  This will make Assistant update the buttons state to be able to continue
   --  the task.
   --  Since: gtk+ 2.10
   --  "page": a page of Assistant
   --  "complete": the completeness status of the page

   function Get_Page_Header_Image
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class)
       return Gdk.Pixbuf.Gdk_Pixbuf;
   pragma Obsolescent (Get_Page_Header_Image);
   procedure Set_Page_Header_Image
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       Pixbuf    : access Gdk.Pixbuf.Gdk_Pixbuf_Record'Class);
   pragma Obsolescent (Set_Page_Header_Image);
   --  Sets a header image for Page.
   --   add your header decoration to the page content instead.
   --  Since: gtk+ 2.10
   --  Deprecated since 3.2, Since GTK+ 3.2, a header is no longer shown;
   --  "page": a page of Assistant
   --  "pixbuf": the new header image Page

   function Get_Page_Side_Image
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class)
       return Gdk.Pixbuf.Gdk_Pixbuf;
   pragma Obsolescent (Get_Page_Side_Image);
   procedure Set_Page_Side_Image
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       Pixbuf    : access Gdk.Pixbuf.Gdk_Pixbuf_Record'Class);
   pragma Obsolescent (Set_Page_Side_Image);
   --  Sets a side image for Page.
   --  This image used to be displayed in the side area of the assistant when
   --  Page is the current page.
   --   shown anymore.
   --  Since: gtk+ 2.10
   --  Deprecated since 3.2, Since GTK+ 3.2, sidebar images are not
   --  "page": a page of Assistant
   --  "pixbuf": the new side image Page

   function Get_Page_Title
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class)
       return UTF8_String;
   procedure Set_Page_Title
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       Title     : UTF8_String);
   --  Sets a title for Page.
   --  The title is displayed in the header area of the assistant when Page is
   --  the current page.
   --  Since: gtk+ 2.10
   --  "page": a page of Assistant
   --  "title": the new title for Page

   function Get_Page_Type
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class)
       return Gtk_Assistant_Page_Type;
   procedure Set_Page_Type
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       The_Type  : Gtk_Assistant_Page_Type);
   --  Sets the page type for Page.
   --  The page type determines the page behavior in the Assistant.
   --  Since: gtk+ 2.10
   --  "page": a page of Assistant
   --  "type": the new type for Page

   function Insert_Page
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class;
       Position  : Gint) return Gint;
   --  Inserts a page in the Assistant at a given position.
   --  Since: gtk+ 2.10
   --  "page": a Gtk.Widget.Gtk_Widget
   --  "position": the index (starting at 0) at which to insert the page, or
   --  -1 to append the page to the Assistant

   procedure Next_Page (Assistant : access Gtk_Assistant_Record);
   --  Navigate to the next page.
   --  It is a programming error to call this function when there is no next
   --  page.
   --  This function is for use when creating pages of the
   --  GTK_ASSISTANT_PAGE_CUSTOM type.
   --  Since: gtk+ 3.0

   function Prepend_Page
      (Assistant : access Gtk_Assistant_Record;
       Page      : access Gtk.Widget.Gtk_Widget_Record'Class) return Gint;
   --  Prepends a page to the Assistant.
   --  Since: gtk+ 2.10
   --  "page": a Gtk.Widget.Gtk_Widget

   procedure Previous_Page (Assistant : access Gtk_Assistant_Record);
   --  Navigate to the previous visited page.
   --  It is a programming error to call this function when no previous page is
   --  available.
   --  This function is for use when creating pages of the
   --  GTK_ASSISTANT_PAGE_CUSTOM type.
   --  Since: gtk+ 3.0

   procedure Remove_Action_Widget
      (Assistant : access Gtk_Assistant_Record;
       Child     : access Gtk.Widget.Gtk_Widget_Record'Class);
   --  Removes a widget from the action area of a Gtk.Assistant.Gtk_Assistant.
   --  Since: gtk+ 2.10
   --  "child": a Gtk.Widget.Gtk_Widget

   procedure Remove_Page
      (Assistant : access Gtk_Assistant_Record;
       Page_Num  : Gint);
   --  Removes the Page_Num's page from Assistant.
   --  Since: gtk+ 3.2
   --  "page_num": the index of a page in the Assistant, or -1 to remove the
   --  last page

   procedure Set_Forward_Page_Func
      (Assistant : access Gtk_Assistant_Record;
       Page_Func : Gtk_Assistant_Page_Func);
   --  Sets the page forwarding function to be Page_Func.
   --  This function will be used to determine what will be the next page when
   --  the user presses the forward button. Setting Page_Func to null will make
   --  the assistant to use the default forward function, which just goes to
   --  the next visible page.
   --  Since: gtk+ 2.10
   --  "page_func": the Gtk.Assistant.Gtk_Assistant_Page_Func, or null to use
   --  the default one

   generic
      type User_Data_Type (<>) is private;
      with procedure Destroy (Data : in out User_Data_Type) is null;
   package Set_Forward_Page_Func_User_Data is

      type Gtk_Assistant_Page_Func is access function (Current_Page : Gint; Data : User_Data_Type) return Gint;
      --  A function used by Gtk.Assistant.Set_Forward_Page_Func to know which is
      --  the next page given a current one. It's called both for computing the
      --  next page when the user presses the "forward" button and for handling
      --  the behavior of the "last" button.
      --  "current_page": The page number used to calculate the next page.
      --  "data": user data.

      procedure Set_Forward_Page_Func
         (Assistant : access Gtk.Assistant.Gtk_Assistant_Record'Class;
          Page_Func : Gtk_Assistant_Page_Func;
          Data      : User_Data_Type);
      --  Sets the page forwarding function to be Page_Func.
      --  This function will be used to determine what will be the next page
      --  when the user presses the forward button. Setting Page_Func to null
      --  will make the assistant to use the default forward function, which
      --  just goes to the next visible page.
      --  Since: gtk+ 2.10
      --  "page_func": the Gtk.Assistant.Gtk_Assistant_Page_Func, or null to
      --  use the default one
      --  "data": user data for Page_Func

   end Set_Forward_Page_Func_User_Data;

   procedure Update_Buttons_State (Assistant : access Gtk_Assistant_Record);
   --  Forces Assistant to recompute the buttons state.
   --  GTK+ automatically takes care of this in most situations, e.g. when the
   --  user goes to a different page, or when the visibility or completeness of
   --  a page changes.
   --  One situation where it can be necessary to call this function is when
   --  changing a value on the current page affects the future page flow of the
   --  assistant.
   --  Since: gtk+ 2.10

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Buildable"

   package Implements_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_Assistant_Record, Gtk_Assistant);
   function "+"
     (Widget : access Gtk_Assistant_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_Assistant
   renames Implements_Buildable.To_Object;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "apply"
   --     procedure Handler (Self : access Gtk_Assistant_Record'Class);
   --  The ::apply signal is emitted when the apply button is clicked.
   --  The default behavior of the Gtk.Assistant.Gtk_Assistant is to switch to
   --  the page after the current page, unless the current page is the last
   --  one.
   --  A handler for the ::apply signal should carry out the actions for which
   --  the wizard has collected data. If the action takes a long time to
   --  complete, you might consider putting a page of type
   --  %GTK_ASSISTANT_PAGE_PROGRESS after the confirmation page and handle this
   --  operation within the Gtk.Assistant.Gtk_Assistant::prepare signal of the
   --  progress page.
   --
   --  "cancel"
   --     procedure Handler (Self : access Gtk_Assistant_Record'Class);
   --  The ::cancel signal is emitted when then the cancel button is clicked.
   --
   --  "close"
   --     procedure Handler (Self : access Gtk_Assistant_Record'Class);
   --  The ::close signal is emitted either when the close button of a summary
   --  page is clicked, or when the apply button in the last page in the flow
   --  (of type %GTK_ASSISTANT_PAGE_CONFIRM) is clicked.
   --
   --  "prepare"
   --     procedure Handler
   --       (Self : access Gtk_Assistant_Record'Class;
   --        Page : Gtk.Widget.Gtk_Widget);
   --    --  "page": the current page
   --  The ::prepare signal is emitted when a new page is set as the
   --  assistant's current page, before making the new page visible.
   --  A handler for this signal can do any preparations which are necessary
   --  before showing Page.

   Signal_Apply : constant Glib.Signal_Name := "apply";
   Signal_Cancel : constant Glib.Signal_Name := "cancel";
   Signal_Close : constant Glib.Signal_Name := "close";
   Signal_Prepare : constant Glib.Signal_Name := "prepare";

end Gtk.Assistant;