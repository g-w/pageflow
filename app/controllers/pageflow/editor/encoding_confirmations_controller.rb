module Pageflow
  module Editor
    class EncodingConfirmationsController < Pageflow::ApplicationController
      respond_to :json

      before_filter :authenticate_user!

      def create
        entry = DraftEntry.find(params[:entry_id])

        authorize!(:confirm_encoding, entry.to_model)
        @encoding_confirmation = build_encoding_confirmation(entry)
        @encoding_confirmation.save!

        head :ok
      rescue EncodingConfirmation::QuotaExceededError
        render(action: :check, status: :forbidden)
      end

      def check
        entry = DraftEntry.find(params[:entry_id])

        authorize!(:confirm_encoding, entry.to_model)
        @encoding_confirmation = build_encoding_confirmation(entry)
      end

      private

      def build_encoding_confirmation(entry)
        EncodingConfirmation.new(entry, encoding_confirmation_params, encoding_quota)
      end

      def encoding_confirmation_params
        params.require(:encoding_confirmation).permit(video_file_ids: [], audio_file_ids: [])
      end

      def encoding_quota
        Pageflow.config.quotas.get(:encoding, current_user.account)
      end
    end
  end
end
