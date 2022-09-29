module Api
  class ResourcesController < ApiApplicationController
    def show
      resource = Resource.find(params[:id])
      render json: resource
    end

    def index
      learning_unit = LearningUnit.find(params[:learning_unit_id])
      resources = learning_unit.resources
      render json: resources
    end

    def average_evaluation
      resource = Resource.find(params[:resource_id])
      average_evaluation = ResourceEvaluation.where(resource:)
                                             .average(:evaluation)
      evaluation = if average_evaluation
                     average_evaluation.round(1)
                   else
                     'Sin evaluación'
                   end
      render json: { average_evaluation: evaluation }
    end

    def comments
      comments = Resource.find(params[:resource_id])
                         .resource_comments
                         .includes(:user)
      comments_data = extract_comments_data(comments)
      render json: comments_data
    end

    private

    def extract_comments_data(comments)
      comments_data = []
      comments.each do |comment|
        comments_data << {
          id: comment.id,
          created_at: comment.created_at.strftime('%Y/%m/%d %H:%M:%S'),
          username: comment.user.name,
          content: comment.content
        }
      end
    end
  end
end
