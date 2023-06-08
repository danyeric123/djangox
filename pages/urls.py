from django.urls import path

from .views import AboutPageView, HomePageView, UserListView

urlpatterns = [
    path("", HomePageView.as_view(), name="home"),
    path("about/", AboutPageView.as_view(), name="about"),
    path("users/", UserListView.as_view(), name="user_list")
]
