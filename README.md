# NEXUS Chat

Supabase-backed room chat with persistent message history, live presence, and one-to-one browser voice calls.

## Supabase setup

1. Create a Supabase project and wait for it to finish provisioning.
2. In **Authentication → Sign In / Providers**, enable **Anonymous sign-ins**. The app uses anonymous Supabase Auth sessions; no email or password is collected.
3. Open **SQL Editor**, run [`supabase/schema.sql`](./supabase/schema.sql).
4. In **Database → Replication** (or **Database → Publications**), enable Realtime/Postgres Changes for `public.room_messages`.
5. In **Project Settings → API**, copy the Project URL and the **publishable key** (or legacy `anon` key). Never use the `service_role` key in this browser app.
6. Copy `.env.example` to `.env.local` in the project root and replace the two placeholder values:

   ```env
   VITE_SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
   VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY
   ```

7. Restart the Vite app, choose a display name and a room ID, then join the same room from another browser/device. Messages are stored in Supabase and the online list uses Realtime Presence.
8. Click the phone icon beside an online person to call. Both users need to allow microphone access and use HTTPS (or localhost during local development).

### Voice networking

Call signaling uses private Supabase Realtime channels. Audio itself is peer-to-peer WebRTC. The app uses a public STUN server for initial connectivity; some corporate, school, or restrictive mobile networks require a TURN relay. For dependable production calls, configure a TURN service and add its ICE server credentials in `createPeerConnection` in `src/App.tsx`. Never expose long-lived TURN credentials in a public client bundle; use short-lived credentials from a secured service.

### Access and data notes

- Room IDs are discoverable identifiers, not passwords. Anyone who knows a room ID and can create an anonymous session can join that room.
- The included policies allow authenticated anonymous sessions to read and send messages in any room. Do not use this setup for sensitive conversations. For private rooms, add verified accounts and room membership/passcode verification enforced by trusted server code.
- Messages remain in `room_messages` until you remove them from Supabase. The browser app does not delete room history.
- Realtime voice calls are one-to-one; group calls and calls through networks requiring TURN need additional infrastructure.
