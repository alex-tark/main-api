module.exports = {
  jsonResponse: (res, success, message, status, data) =>
    res.status(status).json { success: success, message: message, data: data }
}