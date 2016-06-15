require! {
	\redux-devtools : {create-dev-tools}
	\redux-devtools-log-monitor : {default: LogMonitor}
	\redux-devtools-dock-monitor : {default: DockMonitor}
}

module.exports = create-dev-tools do
	_ DockMonitor, toggle-visibility-key: 'ctrl-h', change-position-key: 'ctrl-q',
		_ LogMonitor
