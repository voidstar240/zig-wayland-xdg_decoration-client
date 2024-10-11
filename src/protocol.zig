// THIS FILE IS GENERATED FROM A WAYLAND PROTOCOL XML FILE. ANY CHANGES
// MADE TO THIS FILE WILL BE ERASED NEXT TIME THE PROTOCOL IS UPDATED.

// Copyright © 2018 Simon Ser
// 
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice (including the next
// paragraph) shall be included in all copies or substantial portions of the
// Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

const this_protocol = @This();
const xdg = struct {
    usingnamespace this_protocol;
    usingnamespace @import("wayland-xdg_shell-client");
};
const wl = @import("wayland-client");

const Fixed = wl.Fixed;
const FD = wl.FD;
const AnonymousEvent = wl.AnonymousEvent;
const RequestError = wl.RequestError;
const DecodeError = wl.DecodeError;
const decodeEvent = wl.decodeEvent;
const WaylandContext = wl.WaylandContext;
const sendRequestRaw = wl.wire.sendRequestRaw;
const EventField = wl.wire.EventField;


/// This interface allows a compositor to announce support for server-side
/// decorations.
/// 
/// A window decoration is a set of window controls as deemed appropriate by
/// the party managing them, such as user interface components used to move,
/// resize and change a window's state.
/// 
/// A client can use this protocol to request being decorated by a supporting
/// compositor.
/// 
/// If compositor and client do not negotiate the use of a server-side
/// decoration using this protocol, clients continue to self-decorate as they
/// see fit.
/// 
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
pub const DecorationManagerV1 = struct {
    id: u32,
    version: u32 = 1,

    const Self = @This();

    pub const interface_str = "zxdg_decoration_manager_v1";

    pub const opcode = struct {
        pub const request = struct {
            pub const destroy: u16 = 0;
            pub const get_toplevel_decoration: u16 = 1;
        };
    };

    /// Destroy the decoration manager. This doesn't destroy objects created
    /// with the manager.
    pub fn destroy(self: Self, ctx: *const WaylandContext) RequestError!void {
        const args = .{
        };
        const fds = [_]FD{ };
        const socket = ctx.socket.handle;
        const op = Self.opcode.request.destroy;
        const iov_len = 1;
        try sendRequestRaw(socket, self.id, op, iov_len, args, fds);
    }

    /// Create a new decoration object associated with the given toplevel.
    /// 
    /// Creating an xdg_toplevel_decoration from an xdg_toplevel which has a
    /// buffer attached or committed is a client error, and any attempts by a
    /// client to attach or manipulate a buffer prior to the first
    /// xdg_toplevel_decoration.configure event must also be treated as
    /// errors.
    pub fn getToplevelDecoration(self: Self, ctx: *const WaylandContext, id: u32, toplevel: xdg.Toplevel) RequestError!xdg.ToplevelDecorationV1 {
        const new_obj = xdg.ToplevelDecorationV1 {
            .id = id
        };

        const args = .{
            id,
            toplevel.id,
        };
        const fds = [_]FD{ };
        const socket = ctx.socket.handle;
        const op = Self.opcode.request.get_toplevel_decoration;
        const iov_len = 3;
        try sendRequestRaw(socket, self.id, op, iov_len, args, fds);
        return new_obj;
    }

};

/// The decoration object allows the compositor to toggle server-side window
/// decorations for a toplevel surface. The client can request to switch to
/// another mode.
/// 
/// The xdg_toplevel_decoration object must be destroyed before its
/// xdg_toplevel.
pub const ToplevelDecorationV1 = struct {
    id: u32,
    version: u32 = 1,

    const Self = @This();

    pub const interface_str = "zxdg_toplevel_decoration_v1";

    pub const opcode = struct {
        pub const request = struct {
            pub const destroy: u16 = 0;
            pub const set_mode: u16 = 1;
            pub const unset_mode: u16 = 2;
        };
        pub const event = struct {
            pub const configure: u16 = 0;
        };
    };

    pub const Error = enum(u32) {
        unconfigured_buffer = 0, // xdg_toplevel has a buffer attached before configure
        already_constructed = 1, // xdg_toplevel already has a decoration object
        orphaned = 2, // xdg_toplevel destroyed before the decoration object
    };

    /// These values describe window decoration modes.
    pub const Mode = enum(u32) {
        client_side = 1, // no server-side window decoration
        server_side = 2, // server-side window decoration
    };

    /// Switch back to a mode without any server-side decorations at the next
    /// commit.
    pub fn destroy(self: Self, ctx: *const WaylandContext) RequestError!void {
        const args = .{
        };
        const fds = [_]FD{ };
        const socket = ctx.socket.handle;
        const op = Self.opcode.request.destroy;
        const iov_len = 1;
        try sendRequestRaw(socket, self.id, op, iov_len, args, fds);
    }

    /// Set the toplevel surface decoration mode. This informs the compositor
    /// that the client prefers the provided decoration mode.
    /// 
    /// After requesting a decoration mode, the compositor will respond by
    /// emitting an xdg_surface.configure event. The client should then update
    /// its content, drawing it without decorations if the received mode is
    /// server-side decorations. The client must also acknowledge the configure
    /// when committing the new content (see xdg_surface.ack_configure).
    /// 
    /// The compositor can decide not to use the client's mode and enforce a
    /// different mode instead.
    /// 
    /// Clients whose decoration mode depend on the xdg_toplevel state may send
    /// a set_mode request in response to an xdg_surface.configure event and wait
    /// for the next xdg_surface.configure event to prevent unwanted state.
    /// Such clients are responsible for preventing configure loops and must
    /// make sure not to send multiple successive set_mode requests with the
    /// same decoration mode.
    pub fn setMode(self: Self, ctx: *const WaylandContext, mode: Mode) RequestError!void {
        const args = .{
            @intFromEnum(mode),
        };
        const fds = [_]FD{ };
        const socket = ctx.socket.handle;
        const op = Self.opcode.request.set_mode;
        const iov_len = 2;
        try sendRequestRaw(socket, self.id, op, iov_len, args, fds);
    }

    /// Unset the toplevel surface decoration mode. This informs the compositor
    /// that the client doesn't prefer a particular decoration mode.
    /// 
    /// This request has the same semantics as set_mode.
    pub fn unsetMode(self: Self, ctx: *const WaylandContext) RequestError!void {
        const args = .{
        };
        const fds = [_]FD{ };
        const socket = ctx.socket.handle;
        const op = Self.opcode.request.unset_mode;
        const iov_len = 1;
        try sendRequestRaw(socket, self.id, op, iov_len, args, fds);
    }

    /// The configure event configures the effective decoration mode. The
    /// configured state should not be applied immediately. Clients must send an
    /// ack_configure in response to this event. See xdg_surface.configure and
    /// xdg_surface.ack_configure for details.
    /// 
    /// A configure event can be sent at any time. The specified mode must be
    /// obeyed by the client.
    pub const ConfigureEvent = struct {
        self: Self,
        mode: Mode,
    };
    pub fn decodeConfigureEvent(self: Self, event: AnonymousEvent) DecodeError!?ConfigureEvent {
        if (event.self_id != self.id) return null;

        const op = Self.opcode.event.configure;
        if (event.opcode != op) return null;

        const args = [_]EventField{
            .{ .name = "mode", .field_type = .enum_ },
        };
        return try decodeEvent(event, ConfigureEvent, &args);
    }

};

