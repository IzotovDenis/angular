json.array! @activities do |activity|
	json.partial! "dashboard/api/activities/activity", activity: activity
end