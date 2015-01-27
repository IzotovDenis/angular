ready = ->
	$('#orders_from').datepicker
		DefaultDate: new Date(),
		regional: "ru",
		changeMonth: true,
		dateFormat: 'yy-mm-dd',
		numberOfMonths: 1,
		showButtonPanel: true,
		onClose: (selectedDate) ->
			$( "#orders_to" ).datepicker( "option", "minDate", selectedDate );
	$('#orders_to').datepicker
		DefaultDate: "+1w",
		changeMonth: true,
		dateFormat: 'yy-mm-dd'
		numberOfMonths: 1
		onClose: (selectedDate) ->
			$( "#orders_from" ).datepicker( "option", "maxDate", selectedDate );
	$('#group-sort').sortable
		axis: 'y'
		handle: '.handle'
		update: -> 
			$.post($(this).data("update-url"),$(this).sortable('serialize'))
	$('#item-sort').sortable
		axis: 'y'
		handle: '.handle'
		update: -> 
			$.post($(this).data("update-url"),$(this).sortable('serialize'))
	$('.promo-sort').sortable
		axis: 'y'
		handle: '.handle'
		update: -> 
			$.post($(this).data("update-url"),$(this).sortable('serialize'))
	$('.slider-sort').sortable
		axis: 'y'
		handle: '.handle'
		update: -> 
			$.post($(this).data("update-url"),$(this).sortable('serialize'))
	$('#users').dataTable
		"iDisplayLength": 25
		language:
			"sProcessing":   "Подождите..."
			"sLengthMenu":   "Показать _MENU_ записей"
			"sZeroRecords":  "Записи отсутствуют."
			"sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей"
			"sInfoEmpty":    "Записи с 0 до 0 из 0 записей"
			"sInfoFiltered": "(отфильтровано из _MAX_ записей)"
			"sInfoPostFix":  ""
			"sSearch":       "Поиск:"
			"sUrl":          ""
			"oPaginate":
		        "sFirst": "Первая",
		        "sPrevious": "Предыдущая",
		        "sNext": "Следующая",
		        "sLast": "Последняя"
		fnRowCallback: (nRow, mData, iDisplayIndex) ->
			$('.editable').editable()
	$('.editable').editable()
	$(".now_button_submit").change ->
			$(this).parent().submit()
	$("#get_one_item_for_offer").submit (event) ->
		$.ajax 
			url: "/items/" + $(this).find("#id").val() + ".json	"
			success: (data) ->
				item_tmpl(data)
		false
	$("#offer_form").submit (event) ->
		a = []
		$(".item").each (index) ->
			a.push($(this).data("kod"))
		$("#items_array").val(a)
		$(this).submit()
	$("#get_range_items_for_offer").submit (event) ->
		$.ajax
			url: "/items/range"
			type: "POST"
			dataType: "JSON"
			data:
				start: $(this).find("#start").val()
				end: $(this).find("#end").val()
			success: (data) ->
				$.each data.items, (i, item) ->
					item_tmpl(item)
		false
	$("#get_group_items_for_offer").submit (event) ->
		$.ajax
			url: "/groups/" + $(this).find("#group_id").val() + ".json"
			success: (data) ->
				$.each data.items, (i, item) ->
					item_tmpl(item)
		false

@item_tmpl = (data) ->
	if $(".item*[data-kod='" + data.kod + "']").index() < 0 
		item = "<tr class='item tr_middle' data-kod='" + data.kod + "'><td class='center photo'><img src='" + data.img + "'></td>" + "<td class='kod'><div class='table_kod_lable'>код:</div><div class='item_kod table_kod_value'>" + data.kod + "</div><div class='table_kod_lable'>артикул:</div> <div class='item_article table_kod_value'>" + data.article + "</div><td class='title'>" + data.title + "</td>" + "<td><span class='btn btn-danger btn-xs action-delete-offer-item'>Удалить</span></td></tr>"
		$("#offer-items-list").append(item)

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).on "click", ".action-delete-offer-item", ->
	$(this).closest("tr").remove()


@ser_items = ->
	items = []
	$("tr.item").each ->
		items.push($(this).data('id'))
	console.log(items)
	$("#offer_store").val(items)