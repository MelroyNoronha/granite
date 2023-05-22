# frozen_string_literal: true

json.task do
  json.partial! "tasks/task", task: @task

  json.task_owner do
    json.extract! @task.task_owner,
      :name
  end

  json.comments @comments do |comment|
    json.extract! comment,
      :id,
      :content,
      :created_at
  end
end
