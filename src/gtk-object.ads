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

--  <description>
--  This is the base class of the widget hierarchy.
--  Everything in GtkAda inherits from this class Gtk_Object, except for a few
--  structures in the Gdk.* packages (low-level drawing routines).
--
--  This class provides a set of handful features that you can choose to reuse
--  in your applications:
--
--  - Reference counting: an object is not deleted while there exists at least
--    one reference to it. Altough GtkAda mostly takes care of that aspect
--    transparently, you might need in some obscure cases to increment or
--    decrement the reference counting for a widget manually, so that it is not
--    removed from memory while you still need it.
--
--  - User data: any number of data can be attached to a Gtk_Object or one of
--    its children. Theses data are references by a String, in a hash-table.
--    GtkAda itself uses this feature to provide an easy conversion between C
--    and Ada widgets.
--    Altough you might prefer to have a completly object-oriented application
--    (and thus associate data through class inheritance), it might be
--    convenient to directly attach some data to your objects.
--
--  - It also contains the basic structures and subprograms required for signal
--    emission. This is of course used to implement the signal mechanism in
--    GtkAda itself, but can also be used to implement a Model/View/Controller
--    framework.
--
--  Note that a lot of functions provided in the C interface are not provided
--  here. They are used to emulate an object-oriented language in C, which can
--  of course be done much more conveniently in Ada. Therefore most of these
--  functions are not needed.
--
--  </description>
--  <c_version>1.2.6</c_version>

with Gdk;
with System;

package Gtk.Object is

   type Gtk_Object_Record is new Gdk.Root_Type with private;
   type Gtk_Object is access all Gtk_Object_Record'Class;

   procedure Ref (Object : access Gtk_Object_Record);
   --  Increments the reference count on the object. Since an object is not
   --  deleted while its reference count is not null, this is a way to
   --  keep an object in memory.
   --  GtkAda mostly takes care of everything, and you should not need this
   --  function except in special cases.

   procedure Unref (Object : access Gtk_Object_Record);
   --  Decrements the reference count for an object. If it reaches 0, then
   --  the memory allocated for the object is freed, and the object no
   --  longer usable.

   procedure Destroy (Object : access Gtk_Object_Record);
   --  Marks the object for destruction.
   --  ???  Should explain the 3-steps destruction process.

   function Get_Type (Object : access Gtk_Object_Record) return Gtk_Type;
   --  Returns the type of OBJECT.
   --  This function is mostly used internally, since in Ada you can simply
   --  test whether an object belong to a class with a statement like:
   --
   --     if Object in Gtk_Button_Record'Class then ...
   --
   --  which is easier.

   -------------
   --  Flags  --
   -------------
   --  <description>
   --  Each object is associated with a set of flags, that reports the state
   --  of the object.
   --  The following flags are known by all objects:
   --
   --  - "Destroyed":
   --     Set if the object is marked as destroyed (if its reference count is
   --     not yet 0, the memory has not been freed, but you should not use it
   --     anyway).
   --
   --  - "Floating":
   --     The objet has no parent yet.  ??? explain the "sink" process.
   --
   --  - "Connected":
   --     Set if the object is connected to at least one handler
   --
   --  - "Constructed":
   --     Set if the object has been fully constructed, and is now usable.
   --     Every time you create an object at the GtkAda level, the object will
   --     be fully constructed, and you shouldn't have to worry about that
   --     flag.
   --
   --  </description>

   Destroyed   : constant := 2 ** 0;
   Floating    : constant := 2 ** 1;
   Connected   : constant := 2 ** 2;
   Constructed : constant := 2 ** 3;

   function Flags (Object : access Gtk_Object_Record) return Guint32;
   --  Returns the flags that are set for the object, as a binary mask.

   procedure Set_Flags (Object : access Gtk_Object_Record;
                        Flags  : in     Guint32);
   --  Sets some specific flags for the object.
   --  FLAGS is a mask that will be added to the current flags of the object.

   procedure Unset_Flags (Object : access Gtk_Object_Record;
                          Flags  : in     Guint32);
   --  Unsets some specific flags for the object.
   --  FLAGS is a mask that will be deleted from the current flags of the
   --  object.

   function Flag_Is_Set (Object : access Gtk_Object_Record;
                         Flag   : in     Guint32)
                        return Boolean;
   --  Returns True if the specific flag FLAG is set for the object

   function Destroyed_Is_Set (Object : access Gtk_Object_Record'Class)
                             return Boolean;
   --  Tests if the Destroyed flag is set for the object.

   function Floating_Is_Set (Object : access Gtk_Object_Record'Class)
                            return Boolean;
   --  Tests if the Floating flag is set for the object.

   function Connected_Is_Set (Object : access Gtk_Object_Record'Class)
                             return Boolean;
   --  Tests if the Connected flag is set for the object.

   function Constructed_Is_Set (Object : access Gtk_Object_Record'Class)
                               return Boolean;
   --  Tests if the Constructed flag is set for the object

   --------------------------
   -- Creating new widgets --
   --------------------------
   --  These types and functions are used only when creating new widget types
   --  directly in Ada. These functions initialize the classes so that they are
   --  correctly recognized by gtk+ itself
   --  See the GtkAda user guide for more information on how to create your
   --  own widget types in Ada.

   type Signal_Array is array (Natural range <>) of String_Ptr;

   procedure Initialize_Class_Record
     (Object       : access Gtk_Object_Record'Class;
      Signals      : Signal_Array;
      Class_Record : in out System.Address);
   --  Creates the class record for a new widget type, which is associated
   --  with Signals'Length new signals. A pointer to the newly created
   --  structure is also returned in Class_Record.
   --  If Class_Record /= System.Null_Address, no memory allocation is
   --  performed, we just reuse it.
   --  Note: The underlying C widget must already have been initialized
   --  by a call to its parent's Initialize function.

   ---------------
   -- User_Data --
   ---------------
   --  This package allow you to associate your own Data to the C widgets. No
   --  type verification is made to check if you are using the correct
   --  matching Get function. This is your own responsability.
   --
   --  We recommend using this package only if you want your data to be
   --  available from your own C code. If you just want to access it from Ada,
   --  you should consider creating a new tagged type instead.

   --  <doc_ignore>

   generic
      type Data_Type (<>) is private;
   package User_Data is
      function Get (Object : access Gtk_Object_Record'Class;
                    Id     : in String := "user_data") return Data_Type;
      --  Gets the information associated with the key ID.
      --  Raises Gtkada.Types.Data_Error if there is none.

      procedure Set (Object : access Gtk_Object_Record'Class;
                     Data   : in Data_Type;
                     Id     : in String := "user_data");
      --  Associates some new user data with the object.
      --  The strings starting with "gtkada_" are reserved for GtkAda's
      --  internal use, please avoid using them.

      procedure Remove (Object : access Gtk_Object_Record'Class;
                        Id     : in String := "user_data");
      --  Remove some data from the object

      function Get (Object : access Gtk_Object_Record'Class;
                    Id     : in Glib.GQuark)
                   return Data_Type;
      --  Same function as Get above, but uses directly the Quark associated
      --  with the string, which speeds up the access time significantly.

      procedure Set (Object : access Gtk_Object_Record'Class;
                     Data   : in Data_Type;
                     Id     : in Glib.GQuark);
      --  Same function as Set above, but uses directly the Quark associated
      --  with the string, which speeds up the access time significantly.

      procedure Remove (Object : access Gtk_Object_Record'Class;
                        Id     : in Glib.GQuark);
      --  Same function as Remove above, but uses directly the Quark associated
      --  with the string, which speeds up the access time significantly.

   end User_Data;

   --  </doc_ignore>

   ----------------------------
   -- Support for GATE/DGATE --
   ----------------------------

   procedure Generate (N      : in Node_Ptr;
                       File   : in File_Type);
   --  Gate internal function

   procedure Generate (Object : in out Gtk_Object; N : in Node_Ptr);
   --  Dgate internal function

   -------------
   -- Signals --
   -------------

   --  <signals>
   --  The following new signals are defined for this widget:
   --
   --  - "destroy"
   --    procedure Handler (Object : access Gtk_Object_Record'Class);
   --
   --    Raised when the object is about to be destroyed. The "destroyed"
   --    flag has been set on the object first. Handlers should not keep
   --    a reference on the object.
   --    The default implementation destroys all the handlers.
   --  </signals>

private
   type Gtk_Object_Record is new Gdk.Root_Type with null record;

   pragma Inline (Destroyed_Is_Set);
   pragma Inline (Floating_Is_Set);
   pragma Inline (Connected_Is_Set);
   pragma Inline (Constructed_Is_Set);

end Gtk.Object;

--  Functions that have no Ada equivalent:
--  - gtk_object_class_user_signal_new
--  - gtk_object_class_user_signal_newv
--  - gtk_object_new
--  - gtk_object_newv
--  - gtk_object_default_construct
--  - gtk_object_constructed
--  - gtk_object_sink
--  - gtk_object_weakref
--  - gtk_object_weakunref
--  - gtk_object_getv
--  - gtk_object_get
--  - gtk_object_set
--  - gtk_object_setv
--  - gtk_object_query_args
--  - gtk_object_class_add_signals => in Initialize_Class_Record
--  - gtk_object_add_arg_type
