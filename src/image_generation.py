from fastapi import FastAPI, Form, Request, Response
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import boto3
import json
from typing import Annotated
from mangum import Mangum

bedrock_client = boto3.client(service_name="bedrock-runtime")
app = FastAPI()
templates = Jinja2Templates(directory="templates")


# TODO: Consider how to do form inputs with full model and nonetypes
# class GenerateItem(BaseModel):
#     prompt: str
#     negative_prompt: str | None = None
#     count: int = 3
#     strictness: float = 8.0
#     height: int = 512
#     width: int = 512
#     # dimensions: Dimensions
#
#     @field_validator("count")
#     @classmethod
#     def count_limit(cls, v: int) -> int:
#         if v > 5 or v < 1:
#             raise ValueError("Image count must be between 1 and 5")
#         return v
#
#     @field_validator("strictness")
#     @classmethod
#     def strictness_limit(cls, v: float | None) -> float | None:
#         if v > 10 or v < 1.1:
#             raise ValueError("Strictness must be between 1.1 and 10.0")
#
#         return v


@app.post("/generate", response_class=HTMLResponse)
async def generate_images(request: Request, prompt: Annotated[str, Form()], response: Response):
    prompt = {
        "textToImageParams": {"text": prompt},
        "taskType": "TEXT_IMAGE",
        "imageGenerationConfig": {
            "cfgScale": 8.0,
            "seed": 0,
            "quality": "standard",
            "width": 512,
            "height": 512,
            "numberOfImages": 3,
        },
    }

    # if generate_config.negative_prompt is not None:
    #     prompt["textToImageParams"]["negativeText"] = generate_config.negative_prompt

    response = bedrock_client.invoke_model(body=json.dumps(prompt),
                                           modelId="amazon.titan-image-generator-v1",
                                           accept="application/json",
                                           contentType="application/json")

    body = json.loads(response.get("body").read())

    if body.get("error") is not None:
        raise RuntimeError(f"Failed to generate images with error {
                           body.get('error')}")

    response.headers["Access-Control-Allow-Origin"] = "*"
    return templates.TemplateResponse(request=request, name="images.html", context={"images": body.get("images")})


@ app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse(request=request, name="index.html")


handler = Mangum(app)
