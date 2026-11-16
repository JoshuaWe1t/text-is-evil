extends Node

@warning_ignore("unused_signal")
signal reputation_changed(new_value)


@warning_ignore("unused_signal")
signal item_requested(item_id: String)


@warning_ignore("unused_signal")
signal opened_for_editing(item_id: String, node: Node)
@warning_ignore("unused_signal")
signal closed_editing


@warning_ignore("unused_signal")
signal request_open_editor(item_id)
