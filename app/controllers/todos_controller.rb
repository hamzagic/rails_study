class TodosController < ApplicationController
  def index
    todos = Todo.all
    if params[:status] == "false"
      todos = todos.where(completed: false)
    elsif params[:status] == "true"
      todos = todos.where(completed: true)
    end
    render json: todos
  end

  def create
    todo = Todo.new(todos_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { "error": todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    todos = Todo.find(params[:id])
    render json: todos
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    render json: "Todo deleted successfully", status: :no_content
  end

  private

  def todos_params
    params.require(:todo).permit(:title)
  end
end
