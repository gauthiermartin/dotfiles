// Key launcher: mod.open can't pass props, so open the worktree dialog for the focused pane's folder.
import { View, div } from "gpui-kit";
import { props, closeOverlay, openOverlay, focused } from "herdr";

export default class extends View {
  init() {
    const id = props()?.overlay;
    if (id) closeOverlay(id);
    const f = focused();
    openOverlay({ mod: "worktree", kind: "dialog", width: 560, height: 480, props: { space: f?.space, folder: f?.cwd, action: "open" } });
  }
  render() { return div(); }
}
