class Api::V1::TodoItemsController < ApplicationController
    #devise user authentication before reading data. Next: link associated user with todo item
    before_action :authenticate_user!
    before_action :set_todo_item, only: [:show, :edit, :update, :destroy]
    def index
        #displaying all the todo items of the current user
        @todo_items = current_user.todo_items.all
    end
    def show
        if authorized?
            respond_to do |format|
              format.json { render :show }
            end
        else
            handle_unauthorized
        end
    end

    def create
      @todo_item = current_user.todo_items.build(todo_item_params)
      if authorized?
        respond_to do |format|
          if @todo_item.save
            format.json { render :show, status: :created, location: api_v1_todo_item_path(@todo_item) }
          else
            format.json { render json: @todo_item.errors, status: :unprocessable_entity }
          end
        end
      else
        handle_unauthorized
      end
  end

    def update
      if authorized?
          respond_to do |format|
              if @todo_item.update(todo_item_params)
                format.json { render :show, status: :ok, location: api_v1_todo_item_path(@todo_item) }
              else
                format.json { render json: @todo_item.errors, status: :unprocessable_entity }
              end
            end
        else
            handle_unauthorized
        end
    end

    def destroy
        if authorized?
          @todo_item.destroy
          respond_to do |format|
            format.json { head :no_content }
          end
      else
          handle_unauthorized
      end
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

        #todo item params passed into the create method. The required params are the title and whether it's competed or not
        def todo_item_params
            params.require(:todo_item).permit(:title, :complete)
        end

end
