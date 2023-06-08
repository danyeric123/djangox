import asyncio
import requests
import time

import httpx
from django.views.generic import TemplateView


class HomePageView(TemplateView):
    template_name = "pages/home.html"


class AboutPageView(TemplateView):
    template_name = "pages/about.html"

class UserListView(TemplateView):
    template_name = "pages/user_list.html"
    context_object_name = "users"

    async def get(self, request, *args, **kwargs):
        await asyncio.sleep(2)
        context = super().get_context_data(**kwargs)
        async with httpx.AsyncClient() as client:
            response = await client.get("https://dummyjson.com/users")
            context["users"] = response.json()["users"]

        return self.render_to_response(context)
    
    # def get(self, request, *args, **kwargs):
    #     time.sleep(2)
    #     context = super().get_context_data(**kwargs)
    #     context["users"] = requests.get("https://dummyjson.com/users").json()["users"]
    #     return self.render_to_response(context)

