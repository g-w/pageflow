pageflow.NotificationsView = Backbone.Marionette.ItemView.extend({
  className: 'notifications',
  tagName: 'ul',
  template: 'templates/notifications',

  ui: {
    failedCount: '.failed .count',
    uploadingCount: '.uploading .count',
    confirmableFilesCount: '.confirmable_files .count',
  },

  events: {
    'click .retry': function() {
      pageflow.failedRecords.retry();
    }
  },

  onRender: function() {
    this.listenTo(pageflow.entry, 'change:uploading_files_count', this.notifyUploadCount);
    this.listenTo(pageflow.entry, 'change:confirmable_files_count', this.notifyConfirmableFilesCount);

    this.listenTo(pageflow.failedRecords, 'add', this.update);
    this.listenTo(pageflow.failedRecords, 'remove', this.update);
    this.listenTo(pageflow.savingRecords, 'add', this.update);
    this.listenTo(pageflow.savingRecords, 'remove', this.update);

    this.update();
    this.notifyConfirmableFilesCount();
  },

  update: function() {
    this.$el.toggleClass('failed', !pageflow.failedRecords.isEmpty());
    this.$el.toggleClass('saving', !pageflow.savingRecords.isEmpty());
    this.ui.failedCount.text(pageflow.failedRecords.length);
  },

  notifyUploadCount: function(model, uploadCount) {
    this.$el.toggleClass('uploading', uploadCount > 0);
    this.ui.uploadingCount.text(uploadCount);
  },

  notifyConfirmableFilesCount: function() {
    var confirmableFilesCount = pageflow.entry.get('confirmable_files_count');

    this.$el.toggleClass('has_confirmable_files', confirmableFilesCount > 0);
    this.ui.confirmableFilesCount.text(confirmableFilesCount);
  }
});