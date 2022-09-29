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
      comments_data = []
      resource_comments = Resource
                                .find(params[:resource_id])
                                .resource_comments
                                .includes(:user)
      resource_comments.each do |comment|
        comments_data << {
          id: comment.id,
          created_at: comment.created_at.strftime('%Y/%m/%d %H:%M:%S'),
          username: comment.user.name,
          content: comment.content
        }
      end
      render json: comments_data
    end
  end
end
