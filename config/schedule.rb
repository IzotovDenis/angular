every 1.hour do
	rake "ts:rebuild"
end

every :reboot do
	rake "ts:start"
end