$(->
  $customerId = undefined
  $logoInput = undefined
  customerURL = undefined
  form = undefined
  hideError = undefined
  showError = undefined
  validateCustomer = undefined
  validatePassword = undefined
  validatePrecense = undefined

  createRow = (customer) ->
    '<tr>' + '<td>' + customer.contact.name + '</td>' + '<td>' + customer.contact.phone_number + '</td>' + '<td>' + customer.email + '</td>' + '<td>' + customer.username + '</td>' + '<td><a href="#">Detail</a></td>' + '<td><a href="#">Reset Password</a></td>' + '<td><a href="#">Lochen</a></td>' + '</tr>'

  updatePagination = (totalPages, defaultPages) ->
    pagination.bootpag
      page: defaultPages
      total: totalPages
    return

  fetchTable = (page) ->
    $.get fetchURL + '?page=' + page, (data) ->
      updatePagination data.customers[1][1], page
      customerContainer.html data.customers[0][1].reduce(((total, customer) ->
        total + createRow(JSON.parse(customer))
      ), '')
      return
    return

  form = $('form#customer')
  $customerId = $('#customer_id')
  customerURL = '/customers/'
  $logoInput = $('.logo input')

  showError = (errorMessage, $input) ->
    $input.siblings('.form-control-feedback').html errorMessage
    $input.closest('.form-group').addClass 'has-error'
    $input.focus()
    return

  hideError = ($input) ->
    $input.siblings('.form-control-feedback').html ''
    $input.closest('.form-group').removeClass 'has-error'
    return

  validatePrecense = ($input, fieldName) ->
    if $input.val() != ''
      hideError $input
      true
    else
      showError 'Please enter ' + fieldName, $input
      false

  validatePassword = ($password, $passwordConfirmation) ->
    if $password.val() != $passwordConfirmation.val()
      showError 'Your password and confirmation password do not match', $passwordConfirmation
      false
    else
      hideError $passwordConfirmation
      true

  validateCustomer = ->
    $customerName = undefined
    $password = undefined
    $passwordConfirmation = undefined
    $username = undefined
    $customerName = $('input[name="customer_name"]')
    $username = $('input[name="username"]')
    $password = $('input[name="password"]')
    $passwordConfirmation = $('input[name="password_confirmation"]')
    validatePrecense($customerName, 'customer name') and validatePrecense($username, 'username') and validatePrecense($password, 'password') and validatePrecense($passwordConfirmation, 'password confirmation') and validatePassword($password, $passwordConfirmation)

  $('.logo input').ezdz
    text: 'Drop images here or click to upload'
    preview: true
    validators:
      maxWidth: 1024
      maxHeight: 768
      maxSize: 1000000
    classes:
      main: 'ezdz-dropzone'
      enter: 'ezdz-enter'
      reject: 'ezdz-reject'
      accept: 'ezdz-accept'
      focus: 'ezdz-focus'
    accept: (filename) ->
      $logoInput.closest('.form-group').removeClass 'has-error'
      return
    reject: (filename) ->
      $logoInput.closest('.form-group').addClass 'has-error'
      return
  $('#applications').selectpicker()
  $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  form.submit ->
    customerId = undefined
    formData = undefined
    url = undefined
    formData = new FormData($(this)[0])
    customerId = $customerId.val()
    url = if customerId != '' then customerURL + customerID else customerURL
    if validateCustomer()
      $.ajax
        url: url
        type: 'POST'
        data: formData
        async: false
        success: (data) ->
          console.log data
          return
        error: (errors) ->
          errors.responseJSON.customers[0][1].forEach (e) ->
            showError e + 'has already been taken', $('#' + e)
            return
          return
        cache: false
        contentType: false
        processData: false
    false
  # Table with dynamic pagination
  fetchURL = '/customers.json'
  customerContainer = $('tbody')
  customers = []
  pagination = $('#pagination').bootpag(
    total: 1
    page: 1
    maxVisible: 5
    leaps: true).on('page', (event, num) ->
    fetchTable num
    return
  )
  fetchTable 1
  return
)
