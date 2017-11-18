# frozen_string_literal: true

require 'link_parser'

class LinksController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @links = links_for_current_user
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(new_link_params)

    if @link.save
      redirect_to links_path
    else
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])

    if @link.update(edit_link_params)
      redirect_to links_path
    else
      render :edit
    end
  end

  def destroy
    Link.delete(params[:id])
    redirect_to links_path
  end

  private

  def links_for_current_user
    if user_signed_in?
      Link.unread.order(created_at: :desc)
    else
      Link.unread.where(public: true).order(created_at: :desc)
    end
  end

  def link_parser
    LinkParser.instance
  end

  def new_link_params
    params.require(:link)
          .permit(:url)
          .tap { |params|
            params.merge!(title: link_parser.title(url: params[:url]))
          }
  end

  def edit_link_params
    params.require(:link)
          .permit(:url, :title, :comment, :public, :tag_list)
  end
end
