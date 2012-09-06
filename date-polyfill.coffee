###
HTML5 Date polyfill | Jonathan Stipe | https://github.com/jonstipe/date-polyfill
###
(($) ->
  $.fn.inputDate = ->
    readDate = (d_str) ->
      if /^\d{4,}-\d\d-\d\d$/.test d_str
        matchData = /^(\d+)-(\d+)-(\d+)$/.exec d_str
        yearPart = parseInt matchData[1], 10
        monthPart = parseInt matchData[2], 10
        dayPart = parseInt matchData[3], 10
        dateObj = new Date yearPart, monthPart - 1, dayPart
        dateObj
      else
        throw "Invalid date string: #{d_str}"

    makeDateString = (date_obj) ->
      d_arr = [date_obj.getFullYear().toString()]
      d_arr.push '-'
      d_arr.push '0' if date_obj.getMonth() < 9
      d_arr.push (date_obj.getMonth() + 1).toString()
      d_arr.push '-'
      d_arr.push '0' if date_obj.getDate() < 10
      d_arr.push date_obj.getDate().toString()
      d_arr.join ''

    makeDateDisplayString = (date_obj, elem) ->
      $elem = $ elem
      day_names = $elem.datepicker "option", "dayNames"
      month_names = $elem.datepicker "option", "monthNames"
      date_arr = [day_names[date_obj.getDay()]]
      date_arr.push ', '
      date_arr.push month_names[date_obj.getMonth()]
      date_arr.push ' '
      date_arr.push date_obj.getDate().toString()
      date_arr.push ', '
      date_arr.push date_obj.getFullYear().toString()
      date_arr.join ''

    increment = (hiddenField, dateBtn, calendarDiv) ->
      $hiddenField = $ hiddenField
      value = readDate $hiddenField.val()
      step = $hiddenField.data "step"
      max = $hiddenField.data "max"
      if !step? || step == 'any'
        value.setDate value.getDate() + 1
      else
        value.setDate value.getDate() + step
      value.setTime max.getTime() if max? && value > max
      value = stepNormalize value, hiddenField
      $hiddenField.val(makeDateString(value)).change()
      $(dateBtn).text makeDateDisplayString value, calendarDiv
      $(calendarDiv).datepicker "setDate", value
      null

    decrement = (hiddenField, dateBtn, calendarDiv) ->
      $hiddenField = $ hiddenField
      value = readDate $hiddenField.val()
      step = $hiddenField.data "step"
      min = $hiddenField.data "min"
      if !step? || step == 'any'
        value.setDate value.getDate() - 1
      else
        value.setDate value.getDate() - step
      value.setTime min.getTime() if min? && value < min
      value = stepNormalize value, hiddenField
      $hiddenField.val(makeDateString(value)).change()
      $(dateBtn).text makeDateDisplayString value, calendarDiv
      $(calendarDiv).datepicker "setDate", value
      null

    stepNormalize = (inDate, hiddenField) ->
      $hiddenField = $ hiddenField
      step = $hiddenField.data "step"
      min = $hiddenField.data "min"
      max = $hiddenField.data "max"
      if step? && step != 'any'
        kNum = inDate.getTime()
        raisedStep = step * 86400000
        min ?= new Date 1970, 0, 1
        minNum = min.getTime()
        stepDiff = (kNum - minNum) % raisedStep
        stepDiff2 = raisedStep - stepDiff
        if stepDiff == 0
          inDate
        else
          if stepDiff > stepDiff2
            new Date(inDate.getTime() + stepDiff2)
          else
            new Date(inDate.getTime() - stepDiff)
      else
        inDate

    $(this).filter('input[type="date"]').each () ->
      $this = $ this
      value = $this.attr 'value'
      min = $this.attr 'min'
      max = $this.attr 'max'
      step = $this.attr 'step'
      className = $this.attr 'class'
      style = $this.attr 'style'
      if value? && /^\d{4,}-\d\d-\d\d$/.test value
        value = readDate value
      else
        value = new Date()
      if min?
        min = readDate min
        value.setTime min.getTime() if (value < min)
      if max?
        max = readDate max
        value.setTime max.getTime() if (value > max)
      if step? and step != 'any'
        step = parseInt step, 10
      hiddenField = document.createElement 'input'
      $hiddenField = $ hiddenField
      $hiddenField.attr
        type: "hidden"
        name: $this.attr 'name'
        value: makeDateString value
      $hiddenField.data
        min: min
        max: max
        step: step

      value = stepNormalize value, hiddenField
      $hiddenField.attr 'value', makeDateString(value)

      calendarContainer = document.createElement 'span'
      $calendarContainer = $ calendarContainer
      $calendarContainer.attr 'class', className if className?
      $calendarContainer.attr 'style', style if style?
      calendarDiv = document.createElement 'div'
      $calendarDiv = $ calendarDiv
      $calendarDiv.css
        display: 'none'
        position: 'absolute'
      dateBtn = document.createElement 'button'
      $dateBtn = $ dateBtn
      $dateBtn.addClass 'date-datepicker-button'
      
      $this.replaceWith hiddenField
      $calendarContainer.insertAfter hiddenField
      $dateBtn.appendTo calendarContainer
      $calendarDiv.appendTo calendarContainer

      $calendarDiv.datepicker
        dateFormat: 'MM dd, yy'
        showButtonPanel: true
        beforeShowDay: (dateObj) ->
          if (!step? || step == 'any')
            [true, '']
          else
            min ?= new Date 1970, 0, 1
            dateDays = Math.floor(dateObj.getTime() / 86400000)
            minDays = Math.floor(min.getTime() / 86400000)
            [((dateDays - minDays) % step == 0), '']

      $dateBtn.text makeDateDisplayString(value, calendarDiv)

      $calendarDiv.datepicker "option", "minDate", min if min?
      $calendarDiv.datepicker "option", "maxDate", max if max?

      if Modernizr.csstransitions
        calendarDiv.className = "date-calendar-dialog date-closed"
        $dateBtn.click (event) ->
          $calendarDiv.off 'transitionend oTransitionEnd webkitTransitionEnd MSTransitionEnd'
          calendarDiv.style.display = 'block'
          calendarDiv.className = "date-calendar-dialog date-open"
          event.preventDefault()
          false
        closeFunc = (event) ->
          if calendarDiv.className == "date-calendar-dialog date-open"
            transitionend_function = (event, ui) ->
              calendarDiv.style.display = 'none'
              $calendarDiv.off "transitionend oTransitionEnd webkitTransitionEnd MSTransitionEnd", transitionend_function
              null
            $calendarDiv.on "transitionend oTransitionEnd webkitTransitionEnd MSTransitionEnd", transitionend_function
            calendarDiv.className = "date-calendar-dialog date-closed"
          event.preventDefault() if event?
          null
      else
        $dateBtn.click (event) ->
          $calendarDiv.fadeIn 'fast'
          event.preventDefault()
          false
        closeFunc = (event) ->
          $calendarDiv.fadeOut 'fast'
          event.preventDefault() if event?
          null

      $calendarDiv.mouseleave closeFunc
      $calendarDiv.datepicker "option", "onSelect", (dateText, inst) ->
        dateObj = $.datepicker.parseDate 'MM dd, yy', dateText
        $hiddenField.val(makeDateString(dateObj)).change()
        $dateBtn.text makeDateDisplayString dateObj, calendarDiv
        closeFunc()
        null

      $calendarDiv.datepicker "setDate", value
      $dateBtn.on
        DOMMouseScroll: (event) ->
          if event.originalEvent.detail < 0
            increment hiddenField, dateBtn, calendarDiv
          else
            decrement hiddenField, dateBtn, calendarDiv
          event.preventDefault()
          null
        mousewheel: (event) ->
          if event.originalEvent.wheelDelta > 0
            increment hiddenField, dateBtn, calendarDiv
          else
            decrement hiddenField, dateBtn, calendarDiv
          event.preventDefault()
          null
        keypress: (event) ->
          if event.keyCode == 38 # up arrow
            increment hiddenField, dateBtn, calendarDiv
            event.preventDefault()
          else if event.keyCode == 40 # down arrow
            decrement hiddenField, dateBtn, calendarDiv
            event.preventDefault()
          null
      null
    this
  $ ->
    $('input[type="date"]').inputDate() unless Modernizr.inputtypes.date
    null
  null
)(jQuery)