import { Controller } from "@hotwired/stimulus";

export default class FavoriteToggleController extends Controller {
  connect(): void {
    console.log("The controller is connected");
  }
}
