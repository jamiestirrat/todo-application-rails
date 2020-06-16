class Api::V1::TodoItemsController < ApplicationController
    #devise user authentication before reading data. Next: link associated user with todo item
    before_action :authenticate_user!
    before_action :set_todo_item, only: [:show, :edit, :update, :destroy]
    def index
        #displaying all the todo items of the current user
        @todo_items = current_user.todo_items.all
    end
    def show
    end
    def create
    end
    def update
    end
    def destroy
    end
    #the private set_todo_item will find the todo item based on the id in the URL. It's private as we don't want users to access.
    private
        def set_todo_item
            @todo_item = TodoItem.find(params[:id])
        end

        #linking authenticated user with todo item
        #this works as devise has a helper method called current user, returning the currently signed in user.
        #so the authorized method will return true if the todo_item of a user matches the currently signed in user.
        #after this we want to handle requests that are not authorized - where the endpoint does not belong to the user
        def authorized?
            @todo_item.user == current_user
        end

        #this method checks to see if request is unauthorized and if it is not it returns jbuilder unauthorized view.
        #We also take the responsibility of returning the correct HTTP status code
        def handle_unauthorized
            unless authorized?
              respond_to do |format|
                format.json { render :unauthorized, status: 401 }
              end
            end
        end

end
