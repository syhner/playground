import { cosineSimilarity, embed, embedMany } from "ai";
import { lmEmbeddingModel } from "./00-models";

const values = ["dog", "cat", "car", "bike"];

const embedResult = await embedMany({
  model: lmEmbeddingModel,
  values,
});

const vectorDb = embedResult.embeddings.map((embedding, index) => ({
  value: values[index],
  embedding,
}));

const searchTerm = await embed({
  model: lmEmbeddingModel,
  value: "feline",
});

const similarities = vectorDb
  .map((vector) => ({
    value: vector.value,
    similarity: cosineSimilarity(vector.embedding, searchTerm.embedding),
  }))
  .sort((a, b) => b.similarity - a.similarity);

console.log(similarities);
