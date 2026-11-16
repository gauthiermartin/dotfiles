// Key launcher: mod.open can't pass props, so open the worktree dialog for the focused pane's folder.
import { View, div } from "gpui-kit";
import { props, closeOverlay, openOverlay, focused } from "herdr";

export default class extends View {
  init() {
    const id = props()?.overlay;
    if (id) closeOverlay(id);
    const f = focused();
    openOverlay({ mod: "worktree", kind: "dialog", width: 440, height: 260, props: { space: f?.space, folder: f?.cwd, action: "remove" } });
  }
  render() { return div(); }
}
