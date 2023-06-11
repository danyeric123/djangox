import asyncio
import time

import httpx
import requests
from django.views.generic import TemplateView


class HomePageView(TemplateView):
    template_name = "pages/home.html"


class AboutPageView(TemplateView):
    template_name = "pages/about.html"


class UserListView(TemplateView):
    template_name = "pages/user_list.html"
    context_object_name = "users"

    async def get(self, request, *args, **kwargs):
        start = time.time()
        context = super().get_context_data(**kwargs)
        async with httpx.AsyncClient() as client:
            response = await asyncio.gather(
                client.get("https://dummyjson.com/users"),
                client.get("https://dummyjson.com/quotes"))
            users = response[0].json()["users"]
            quotes = response[1].json()["quotes"]
            for user, quote in zip(users, quotes):
                user["quote"] = quote
            context["users"] = users
        total = time.time() - start
        context["time_taken"] = total
        print(f"Time taken: {total}")
        return self.render_to_response(context)

    # def get(self, request, *args, **kwargs):
    #     start = time.time()
    #     context = super().get_context_data(**kwargs)
    #     users = requests.get("https://dummyjson.com/users").json()["users"]
    #     quotes = requests.get("https://dummyjson.com/quotes").json()["quotes"]
    #     for user, quote in zip(users, quotes):
    #         user["quote"] = quote
    #     context["users"] = users
    #     total = time.time() - start
    #     context["time_taken"] = total
    #     print(f"Time taken: {total}")
    #     return self.render_to_response(context)


class UserDetailView(TemplateView):
    template_name = "pages/user_detail.html"
    context_object_name = "user"

    # async def get(self, request, *args, **kwargs):
    #     start = time.time()
    #     await asyncio.sleep(2)
    #     context = super().get_context_data(**kwargs)
    #     async with httpx.AsyncClient() as client:
    #         response = await client.get(
    #             f"https://dummyjson.com/user/{kwargs['pk']}")
    #         context["user"] = response.json()
    #     print(f"Time taken: {time.time() - start}")
    #     return self.render_to_response(context)

    def get(self, request, *args, **kwargs):
        start = time.time()
        time.sleep(2)
        context = super().get_context_data(**kwargs)
        context["user"] = requests.get(
            f"https://dummyjson.com/user/{kwargs['pk']}").json()
        print(f"Time taken: {time.time() - start}")
        return self.render_to_response(context)
