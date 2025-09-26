local settings = require("config.settings")

sbar.bar({
	topmost = "window",
	height = settings.dimens.graphics.bar.height,
	color = settings.colors.bg1,
	padding_right = settings.dimens.padding.right,
	padding = settings.dimens.padding.bar,
	padding_left = settings.dimens.padding.left,
	margin = settings.dimens.padding.bar,
	corner_radius = settings.dimens.graphics.background.corner_radius,
	y_offset = settings.dimens.graphics.bar.offset,
	blur_radius = settings.dimens.graphics.blur_radius,
	border_width = 0,
})
