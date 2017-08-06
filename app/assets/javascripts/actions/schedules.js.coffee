$ ->
  $onTime = undefined
  $period = undefined
  $datetimeFields = undefined
  $startDate = undefined
  $endDate = undefined
  $startTime = undefined
  $endTime = undefined
  startDatePicker = undefined
  endDatePicker = undefined

  $period = $('.period')
  $onTime = $('.on-time')

  if $period.length
    $datetimeFields = $('.datetime-fields input')
    $startDate = $('#schedule_start_date')
    $endDate = $('#schedule_end_date')
    $startTime = $('#schedule_start_time')
    $endTime = $('#schedule_end_time')

    if $startDate.parent().hasClass('has-error')
      $('#von').parent().addClass('has-error')
    if $startTime.parent().hasClass('has-error')
      $('#start_time').parent().addClass('has-error')

    if $startDate.val() != ''
      startDatePicker = $('#von').datetimepicker
        format: 'DD.MM.YYYY'
        defaultDate: moment($startDate.val())
        minDate: moment($startDate.val()).subtract(0.1, 'h')
        maxDate: moment($startDate.val()).add(60, 'days')
      if $endDate.val() != ''
        endDatePicker = $('#bis').datetimepicker
          format: 'DD.MM.YYYY'
          defaultDate: moment($endDate.val())
          minDate: moment($startDate.val()).subtract(0.1, 'h')
          maxDate: moment($startDate.val()).add(270, 'days')
      else
        endDatePicker = $('#bis').datetimepicker
          format: 'DD.MM.YYYY'
          minDate: moment().subtract(0.1, 'h')
          maxDate: moment().add(270, 'days')
      $('#datum').datetimepicker
        format: 'DD.MM.YYYY'
        defaultDate: moment($startDate.val())
        minDate: moment($startDate.val()).subtract(0.1, 'h')
        maxDate: moment($startDate.val()).add(60, 'days')
    else
      startDatePicker = $('#von').datetimepicker
        format: 'DD.MM.YYYY'
        minDate: moment().subtract(0.1, 'h')
        maxDate: moment().add(60, 'days')
      endDatePicker = $('#bis').datetimepicker
        format: 'DD.MM.YYYY'
        minDate: moment().subtract(0.1, 'h')
        maxDate: moment().add(270, 'days')
      $('#datum').datetimepicker
        format: 'DD.MM.YYYY'
        minDate: moment().subtract(0.1, 'h')
        maxDate: moment().add(60, 'days')

    if $startTime.val() != ''
      $('#start_time').datetimepicker
        defaultDate:  moment().set({ hour: $startTime.val().split(':')[0], minute: $startTime.val().split(':')[1] })
        format: 'h:mm a'
      $('#ontime-start').datetimepicker
        defaultDate: moment().set({ hour: $startTime.val().split(':')[0], minute: $startTime.val().split(':')[1] })
        format: 'h:mm a'
    else
      $('#start_time').datetimepicker format: 'h:mm a'
      $('#ontime-start').datetimepicker format: 'h:mm a'

    if $endTime.val() != ''
      $('#end_time').datetimepicker
        defaultDate:  moment().set({ hour: $endTime.val().split(':')[0], minute: $endTime.val().split(':')[1] })
        format: 'h:mm a'
    else
      $('#end_time').datetimepicker format: 'h:mm a'

    $('#ontime-duration').slider
      orientation: 'horizontal'
      min: 1
      max: 3
      value: $('#ontime-duration').data('duration')
      step: 1
      animate: true
      stop: (event, ui) ->
        startTime = $startTime.val().split(':')
        $endTime.val(moment().set({ hour: startTime[0], minute: startTime[1] }).add(ui.value, 'h').format('HH:mm'))
        return
    $('input[name="schedule[kind]"]').change ->
      $datetimeFields.val('')
      if this.value == '1'
        $onTime.addClass 'hidden'
        $onTime.find('input').val('')
        $period.removeClass 'hidden'
      else
        $onTime.removeClass 'hidden'
        $period.addClass 'hidden'
        $period.find('input').val('')

    $('input[name="trigger"]').change ->
      if this.value == 'nach_x_minuten'
        $('input#schedule_trigger_time').removeAttr('disabled', 'disabled');
      else
        $('input#schedule_trigger_time').attr('disabled', 'disabled').val(0);

    $('#von').on 'dp.change', (e) ->
      $startDate.val e.date.format('YYYY/MM/DD')
      endDatePicker.datetimepicker('minDate', moment($startDate.val()))
      endDatePicker.datetimepicker('maxDate', moment($startDate.val()).add(270, 'days'))
    $('#bis').on 'dp.change', (e) ->
      $endDate.val e.date.format('YYYY/MM/DD')
    $('#datum').on 'dp.change', (e) ->
      $startDate.val e.date.format('YYYY/MM/DD')
    $('#start_time').on 'dp.change', (e) ->
      $startTime.val e.date.format('HH:mm')
    $('#ontime-start').on 'dp.change', (e) ->
      $startTime.val e.date.format('HH:mm')
      startTime = $startTime.val().split(':')
      $endTime.val(moment().set({ hour: startTime[0], minute: startTime[1] }).add($('#ontime-duration').slider("option", "value"), 'h').format('HH:mm'))
    $('#end_time').on 'dp.change', (e) ->
      $endTime.val e.date.format('HH:mm')

    if $('#schedule_trigger_time').val() > 0
      $('#nach_x_minuten').attr('checked', true)
    else
      $('#sofort').attr('checked', true)
  return
