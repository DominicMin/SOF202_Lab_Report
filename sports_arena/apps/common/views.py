from django.shortcuts import render
from django.views.generic import TemplateView

class HomePageView(TemplateView):
    template_name = "home.html"


def permission_denied_view(request, exception=None):
    """Render a friendly 403 page whenever permission is denied."""
    return render(request, "403.html", status=403)

def denied_view_404(request, exception = None):
    return render(request, "404.html", status=404)