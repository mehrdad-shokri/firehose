import Controller from '@ember/controller'
import { action, computed } from '@ember/object'
import { sort } from '@ember/object/computed'
import { observes } from '@ember-decorators/object'

export default class ReadLinksController extends Controller {
  page = 1
  perPage = 10

  @computed('model')
  get totalPages() {
    return this.model.meta['page-count']
  }

  reset() {
    this.set('page', 1)
    this.set('searchText', '')
  }

  scrollToTop() {
    window.scrollTo(0, 0)
  }

  @observes('searchText')
  searchChanged() {
    this.set('page', 1)
  }

  @action
  updateSearch(e) {
    e.preventDefault()
    this.set('searchTextQP', this.searchText)
  }

  @action
  nextPage() {
    this.incrementProperty('page')
    this.scrollToTop()
  }

  @action
  prevPage() {
    this.decrementProperty('page')
    this.scrollToTop()
  }
}
