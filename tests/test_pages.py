import pytest
from django.urls import reverse


def test_home_page(client):
    url = reverse("home")
    response = client.get(url)
    assert response.status_code == 200


def test_about_page(client):
    url = reverse("about")
    response = client.get(url)
    assert response.status_code == 200


def test_user_list_page(client):
    url = reverse("user_list")
    response = client.get(url)
    assert response.status_code == 200


def test_user_list_page_with_users(client):
    url = reverse("user_list")
    response = client.get(url)
    assert response.status_code == 200
    assert len(response.context["users"]) != 0
