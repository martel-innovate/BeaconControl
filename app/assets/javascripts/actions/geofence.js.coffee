$ ->
  enterActionChk = undefined
  enterActionDetail = undefined
  exitActionChk = undefined
  exitActionDetail = undefined
  geofence = undefined
  geofenceMap = undefined
  latInput = undefined
  lngInput = undefined
  map = undefined
  marker = undefined
  pos = undefined
  radiusInput = undefined
  slider = undefined

  bindInput = (pos) ->
    latInput.val pos.lat
    lngInput.val pos.lng
    if radiusInput.val() == ''
      radiusInput.val 100
    return

  createMap = (pos) ->
    map = new Map(document.getElementById('geofence-map'), {
      lat: pos.lat
      lng: pos.lng
      zoom: 15
      zoomControlOpt: position: 'RIGHT_BOTTOM'
      panControl: false
      streetViewControl: false
      overviewMapControl: false
    }, extendBoundsOnMarkerAdd: false)
    marker = map.addMarker('geofence', pos.lat, pos.lng,
      draggable: true
      dragCallback: (addresses, lat, lng) ->
        geofence.setCenter
          lat: lat
          lng: lng
        latInput.val lat
        lngInput.val lng
      dragCallbackError: (error) ->
        console.log error
    )
    geofence = new (google.maps.Circle)(
      strokeColor: '#FF0000'
      strokeOpacity: 0.8
      strokeWeight: 2
      fillColor: '#FF0000'
      fillOpacity: 0.35
      map: map.map.map
      center: pos
      radius: parseInt(radiusInput.val()))
    google.maps.event.addListener map.map.map, 'click', (event) ->
      marker.setPosition event.latLng
      geofence.setCenter event.latLng
      latInput.val event.latLng.lat()
      lngInput.val event.latLng.lng()
      return
    return

  geofence = undefined
  map = undefined
  marker = undefined
  slider = $('#slider')
  radiusInput = $('#geofence_radius')
  latInput = $('#geofence_latitude')
  lngInput = $('#geofence_longtitude')
  geofenceMap = $('#geofence-map')
  pos = undefined
  if geofenceMap.length > 0
    radiusInput.change (e) ->
      val = undefined
      val = radiusInput.val()
      if val > 50000
        radiusInput.val 50000
        val = 50000
      if val < 10
        radiusInput.val 10
        val = 10
      geofence.setRadius radiusInput.val()
      slider.slider 'value', radiusInput.val()
      return
    slider.slider
      orientation: 'horizontal'
      min: 10
      max: 50000
      value: 100
      step: 10
      animate: false
      stop: (event, ui) ->
        radiusInput.val ui.value
        geofence.setRadius ui.value
        return
    navigator.geolocation.getCurrentPosition ((position) ->
      if latInput.val() == '' and lngInput.val() == ''
        pos =
          lat: position.coords.latitude
          lng: position.coords.longitude
      else
        pos =
          lat: parseFloat(latInput.val())
          lng: parseFloat(lngInput.val())
      bindInput pos
      createMap pos
      return
    ), ((error) ->
      if latInput.val() == '' and lngInput.val() == ''
        pos =
          lat: 52.520645
          lng: 13.409779
      else
        pos =
          lat: parseFloat(latInput.val())
          lng: parseFloat(lngInput.val())
      bindInput pos
      createMap pos
      return
    ), timeout: 5000
    enterActionChk = $('#geofence_enter_action_attributes_active')
    exitActionChk = $('#geofence_exit_action_attributes_active')
    enterActionDetail = enterActionChk.next('.action-details')
    exitActionDetail = exitActionChk.next('.action-details')
    enterActionChk.change (e) ->
      if enterActionChk.is(':checked')
        enterActionDetail.find('select').removeAttr 'disabled', 'disabled'
        enterActionDetail.find('textarea').removeAttr 'disabled', 'disabled'
      else
        enterActionDetail.find('select').attr 'disabled', 'disabled'
        enterActionDetail.find('textarea').attr 'disabled', 'disabled'
      return
    exitActionChk.change (e) ->
      if exitActionChk.is(':checked')
        exitActionDetail.find('select').removeAttr 'disabled', 'disabled'
        exitActionDetail.find('textarea').removeAttr 'disabled', 'disabled'
      else
        exitActionDetail.addClass 'disabled'
        exitActionDetail.find('select').attr 'disabled', 'disabled'
        exitActionDetail.find('textarea').attr 'disabled', 'disabled'
      return
    enterActionChk.trigger 'change'
    exitActionChk.trigger 'change'
  return
return
